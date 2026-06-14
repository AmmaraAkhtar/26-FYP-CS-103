from xml.parsers.expat import model

from django.shortcuts import render
from . serializers import ParentSerializer,OtpSerializer,PasswordResetSerializer, UpdateProfileSerializer,WebUsageDataSerializer,LoginSerializer,ChildSerializer,PairingCodeSerializer,PairedChildSerializer,AppUsageSerializer,AlertSerializer,ChatMessageSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import api_view,permission_classes
from django.contrib.auth import authenticate
import random
from . import models
from django.db.models import Sum
from .app_agent.graph import app_agent
from django.core.mail import send_mail
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import timedelta
import pickle
from .ml_service import ml_service
from .utils import preprocess_app_name
from .web_ml_service import web_ml_service
from urllib.parse import urlparse
import re
from .web_agent.graph import web_graph
import threading
import traceback
import uuid
from .chat_ml_service import ChatMLService
from .chat_ml_service import chat_ml_service
from django.utils.timezone import make_aware
from datetime import datetime
from .chat_agent.graph import chat_agent
from rest_framework.permissions import IsAuthenticated
from datetime import time as dt_time
from django.db.models import Q









# Sign UP API
@api_view(['POST'])
def signup_api(request):
    print("sign UP is called")
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        username = serializer.validated_data['username']
        password = serializer.validated_data['password']
        
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            is_active=False
        )
        send_otp(email)

        # refresh = RefreshToken.for_user(user)
        return Response({
            "message": "OTP sent to your email."
        }, status=status.HTTP_200_OK)
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");
    print(serializer.errors)
    return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

# Log In API 
@api_view(['POST'])
def login_api(request):
    print("request.body (raw):", request.body)
    serializer = LoginSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        user = User.objects.filter(email = email).first()
        print("User found:", user)
        if user is None:
            return Response({"error": "User Not Found"}, status=status.HTTP_404_NOT_FOUND)
        if not user.is_active:
            return Response({"error": "Account is not active. Please verify your email."}, status=status.HTTP_403_FORBIDDEN)
        authenticated_user = authenticate(request, username=user.username, password=password)
        print("Authenticated user:", authenticated_user)
        if authenticated_user is not None:
            refresh = RefreshToken.for_user(authenticated_user)
            
                
            
            return Response({
                    "user": {
                        "username": authenticated_user.username,
                        "email": authenticated_user.email
                    },
                    "tokens": {
                        "refresh": str(refresh),
                        "access": str(refresh.access_token),
                    }
                }, status=status.HTTP_200_OK)
         
    print(serializer.errors)
    return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

# Email Check API
@api_view(['POST'])
def checkEmail_api(request):
    email = request.data.get('email')

        
    try:
            user = User.objects.get(email=email)
            
        
            return Response({"message": "Email exists"}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
            return Response({"error": "User Not Found"}, status=status.HTTP_404_NOT_FOUND)
    

# Reset Password API
@api_view(['POST'])
def resetPassword_api(request):
    print("request.body (raw):", request.body)
    serializer = PasswordResetSerializer(data=request.data)
    if not serializer.is_valid():
        print("Serializer errors:", serializer.errors)
        return Response({"error": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    email = serializer.validated_data['email']
    new_password = serializer.validated_data['new_password']
    try:
        user = User.objects.get(email=email)
        user.set_password(new_password)
        user.save()
        print("Password reset successful")
        return Response({"message": "Password reset successful"}, status=status.HTTP_200_OK)
    except Exception as e:
        print("Error resetting password:", e)
        return Response({"error": "Error Occured"}, status=status.HTTP_404_NOT_FOUND)
    

# Function for OTP Generation
def generate_otp():
    return str(random.randint(1000, 9999))

# Function for sending otp to email

def send_otp(email):
    # serializer = ParentSerializer(data=request.data)
    # email = serializer.validated_data['email']
    try:
        # user = User.objects.get(email=email)
        otp = generate_otp()
        print (otp)
        models.otp.objects.create(email=email,code=otp)
        print("Created")
        send_mail(

            subject='OTP for The Watcher App',
            message=f'Your OTP code is {otp}',
            from_email='22ntucs1145amnaali@gmail.com',
            recipient_list=[email],
            fail_silently=False
           
        )
    except Exception as e:
            print("Error:", e)
            return Response({"error": f"Error sending OTP: {e}"}, status=status.HTTP_400_BAD_REQUEST)

        

# OTP Verification API
@api_view(['POST'])
def otpVerification_api(request):
    print("request.body (raw):", request.body)
    print("request.data (parsed):", request.data)
    serializer = OtpSerializer(data=request.data)
    if serializer.is_valid():
        print("Serializer valid:", serializer.validated_data)
        email = serializer.validated_data['email']
        code = serializer.validated_data['otp']
        
        otp_record = models.otp.objects.filter( email=email,code=code,is_verified=False).last()
        if not otp_record:
            return Response({"result": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)
        if otp_record.is_expired():
            return Response({"result": "OTP has expired"}, status=status.HTTP_400_BAD_REQUEST)
        otp_record.is_verified = True
        otp_record.save()

        user = User.objects.get(email=email)
        user.is_active = True
        user.save()

        otp_record.delete() 

       
        refresh = RefreshToken.for_user(user)
        return Response({
                "user": {
                    "username": user.username,
                    "email": user.email
                },
                "tokens": {
                    "refresh": str(refresh),
                    "access": str(refresh.access_token),
                }
            }, status=status.HTTP_200_OK)
  
    print(serializer.errors)
    return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

# resend otp API
@api_view(['POST'])
def resendOtp_api(request):
    email = request.data.get('email')
    send_otp(email)
    return Response({"message": "OTP resent to your email."}, status=status.HTTP_200_OK)

# Create Child API
@api_view(['POST'])
def createChild_api(request):
    delete_unpaired_children()
    serializer = ChildSerializer(data=request.data)
    print("request.body (raw):", request.data)
    if serializer.is_valid():
        firstname = serializer.validated_data['firstname']
        lastname = serializer.validated_data['lastname']
        age = serializer.validated_data['age']
        screen_time_limit = serializer.validated_data['screen_time_limit']
        parent_email = request.data.get('parent_email')
        user = User.objects.filter(email=parent_email).first()
        pairing_code = generate_unique_code()
        print(pairing_code)
        if models.child.objects.filter(firstname=firstname,lastname=lastname,parent=user).exists():
            print("Child already exists for this parent")
            return Response({"error": "Child already exists for this parent"}, status=400)
        child = models.child.objects.create(firstname=firstname, lastname=lastname, age=age, screen_time_limit=screen_time_limit,parent = user,pairingCode=pairing_code,bedtime_start=serializer.validated_data.get('bedtime_start', '21:00'),   
    bedtime_end=serializer.validated_data.get('bedtime_end', '07:00'),       
    bedtime_enabled=serializer.validated_data.get('bedtime_enabled', True),)
        models.pairingCode.objects.create(pairing_code=pairing_code,parent=user,child=child)    
        send_code(parent_email, pairing_code)
        return Response({
            "message": "Child created successfully",
           
        }, status=status.HTTP_201_CREATED)
    print("Serializer errors:", serializer.errors)
    return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

# Generate Unique code 
def generate_unique_code():
        while True:
            code = str(random.randint(1000, 9999))
            if not models.pairingCode.objects.filter(pairing_code=code).exists():
                return code

# Function for sending pairing code  to parent's email

def send_code(email,code):
    
    try:

       
        
       
        print("Created")
        send_mail(

            subject='Child Agent Pairing Code for The Watcher App',
            message=f'Your pairing code  is {code}',
            from_email='22ntucs1145amnaali@gmail.com',
            recipient_list=[email],
            fail_silently=False
           
        )
    except Exception as e:
            print("Error:", e)
            return Response({"error": f"Error sending OTP: {e}"}, status=status.HTTP_400_BAD_REQUEST)

# pairing code verification API
@api_view(['POST'])
def pairingCodeVerification_api(request):
    serializer = PairingCodeSerializer(data=request.data)
    if not serializer.is_valid():
        print("Serializer errors:", serializer.errors)
        return Response({"error": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    pairing_code = serializer.validated_data['pairing_code']
    try:
        print("Request pairing code:", pairing_code)
        print("Available unused codes:", list(models.pairingCode.objects.filter(is_used=False).values_list('pairing_code', flat=True)))
        code_record = models.pairingCode.objects.filter(pairing_code=pairing_code,is_used=False).order_by('-created_at').first()
        if not code_record:
            print("Invalid pairing code")
            return Response({"error": "Invalid Pairing Code"}, status=status.HTTP_400_BAD_REQUEST)
        if code_record.is_expired():
            print("Pairing code expired")
            return Response({"error": "Pairing Code has expired"}, status=status.HTTP_400_BAD_REQUEST)
        code_record.is_used = True
        code_record.save()

        child = models.child.objects.filter(pairingCode=pairing_code).first()
        if not child:
             return Response({"error": "Child not found"}, status=400)
        screen_limit = child.screen_time_limit
        if child:
            child.is_paired = True
            child.save()

        return Response({"message": "Pairing successful", "screen_limit": screen_limit, "child_id": child.id}, status=status.HTTP_200_OK)
    except Exception as e:
        print("Error during pairing:", e)
        return Response({"error": "Error Occured"}, status=status.HTTP_400_BAD_REQUEST)


# Delete Unpaired Children 
def delete_unpaired_children():
    expire_time = timezone.now() - timedelta(minutes=30)
    expired_codes = models.pairingCode.objects.filter(is_used=False, created_at__lte=expire_time)
    for code in expired_codes:
        models.child.objects.filter(pairingCode=code).delete()
        code.delete()


# Fetch all registered children API
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def fetchChildren_api(request):
    parent_email = request.query_params.get('parent_email')
    user = User.objects.filter(email=parent_email).first()
    if not user:
        return Response({"error": "User Not Found"}, status=status.HTTP_404_NOT_FOUND)
    children = models.child.objects.filter(parent=user)
    serializer = PairedChildSerializer(children, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

# app category prediction model 
# model = None

# def get_model():
#     global model
#     if model is None:
#         with open(r"..\models\App_Analysis_Data\AppAnalysisModel.pkl", "rb") as f:
#             model = pickle.load(f)
#     return model

# Collect data for app usage monitoring 

@api_view(['POST'])
def collectAppUsageData_Api(request):
    try:
        print("app API calling")


        if not request.data:
                return Response({"message": "No data received"}, status=200)

        serializer = AppUsageSerializer(data=request.data)
        print(request.data)
        
        if serializer.is_valid():
            validated_data = serializer.validated_data
            # usage_data = validated_data["usage_data"]
            usage_data = validated_data.get("usage_data", [])

            if not usage_data:
                return Response({"message": "Empty usage data"}, status=200)
            
            #app_names = [app["package_name"] for app in usage_data]
            
            app_names = [preprocess_app_name(app["package_name"]) for app in usage_data]

            # ML prediction
            # model = get_model()
            #category_predictions = app_model.predict(app_names)
            category_predictions = ml_service.predict(app_names)

            result = []

            child_id = validated_data["child_id"]
            child = models.child.objects.get(id=child_id)

            today =  timezone.now().date()
            now_time = timezone.localtime().time()
            # REset on midnight
            if now_time < dt_time(0, 5):  # raat 12:00-12:05 ke beech
                    models.child.objects.filter(parent_unlocked=True).update(parent_unlocked=False)
            
            if is_bedtime(child):
                child.is_locked = True
                child.save()
                return Response({"is_locked": True, "reason": "bedtime"}, status=200)
            

            # Strictly applying screen time limit — agar limit exceed ho jati hai toh chahe koi bhi app use kar raha ho, device ko lock kar do. Isse parents ko ek strong signal milega ki limit important hai, aur unnecessary alerts se bhi bachenge.
            two_days_ago = timezone.now().date() - timedelta(days=1)
            existing_usage = models.appUsage.objects.filter(child=child, date=today)
            merged_existing = {}
            for u in existing_usage:
                pkg = u.package_name
                if pkg not in merged_existing or u.usage_time > merged_existing[pkg]:
                    merged_existing[pkg] = u.usage_time
            total_usage_today = sum(merged_existing.values())  # seconds

            screen_limit_seconds = child.screen_time_limit * 60

            # if total_usage_today >= screen_limit_seconds:
            #     child.is_locked = True
            #     child.save()
            #     return Response({"is_locked": True, "reason": "bedtime"}, status=200)
            if total_usage_today >= screen_limit_seconds:
                if child.parent_unlocked and child.parent_unlocked_at:
                    elapsed = (timezone.now() - child.parent_unlocked_at).total_seconds()
                    # Parent ne unlock kiya tha — 30 min grace period check karo
                    if elapsed < 30 * 60:
                        pass  # Grace period — lock mat karo
                    else:
                        child.parent_unlocked = False
                        child.parent_unlocked_at = None
                        child.is_locked = True
                        child.save()
                        return Response({"is_locked": True, "reason": "screen_limit_after_grace"}, status=200)
                    # Grace period mein hai — lock mat karo
                else:
                    child.is_locked = True
                    child.save()
                    return Response({"is_locked": True, "reason": "screen_limit"}, status=200)
            
            SKIP_PACKAGES = {
            'com.android', 'android',
            'com.samsung.android.app.galaxyfinder',
            'com.samsung.android.bixby.agent',
            'com.google.android.permissioncontroller',
            'com.sec.android.app.launcher',
            'com.samsung.android.dialer',
            'com.example.child_app',
        }
            AGENT_CATEGORIES = {"Social", "Sensitive", "Games", "Entertainment"}
            KNOWN_CATEGORIES = {
    # ── Social Media ──
    'instagram': 'Social',
    'facebook': 'Social',
    'tiktok': 'Social',
    'snapchat': 'Social',
    'twitter': 'Social',
    'pinterest': 'Social',
    'linkedin': 'Social',
    'discord': 'Social',
    'tumblr': 'Social',
    'reddit': 'Social',
    'bereal': 'Social',

    # ── Chatting ──
    'whatsapp': 'Social',
    'telegram': 'Social',
    'signal': 'Social',
    'skype': 'Social',
    'imo': 'Social',
    'viber': 'Social',
    'messenger': 'Social',
    'wechat': 'Social',
    'line': 'Social',

    # ── Entertainment ──
    'youtube': 'Entertainment',
    'netflix': 'Entertainment',
    'spotify': 'Entertainment',
    'twitch': 'Entertainment',
    'dailymotion': 'Entertainment',
    'vimeo': 'Entertainment',
    'soundcloud': 'Entertainment',
    'primevideo': 'Entertainment',
    'hotstar': 'Entertainment',
    'disneyplus': 'Entertainment',
    'hulu': 'Entertainment',
    'tving': 'Entertainment',
    'bigo': 'Entertainment',
    'likee': 'Entertainment',
    'mxtakatak': 'Entertainment',
    'resso': 'Entertainment',
    'jiosaavn': 'Entertainment',
    'gaana': 'Entertainment',

    # ── Games ──
    'roblox': 'Games',
    'pubg': 'Games',
    'freefire': 'Games',
    'free.fire': 'Games',
    'callofduty': 'Games',
    'fortnite': 'Games',
    'minecraft': 'Games',
    'subway': 'Games',
    'candycrush': 'Games',
    'clashofclans': 'Games',
    'brawlstars': 'Games',
    'clashroyale': 'Games',
    'mobilelegends': 'Games',
    'hillclimb': 'Games',
    'templerun': 'Games',
    'angrybirds': 'Games',
    'amongus': 'Games',
    'fingersoft': 'Games',
    'supercell': 'Games',
    'miniclip': 'Games',
    'gameloft': 'Games',
    'eaplay': 'Games',
    'fifamobile': 'Games',
    'efootball': 'Games',
    'ludo': 'Games',
    'carrompool': 'Games',
    '8ballpool': 'Games',
    'gta': 'Games',
    'battleground': 'Games',
    'fpsshooter': 'Games',
    'wordgame': 'Games',
    'solitaire': 'Games',

    # ── Education ──
    'duolingo': 'Education',
    'kahoot': 'Education',
    'quizlet': 'Education',
    'coursera': 'Education',
    'udemy': 'Education',
    'khan': 'Education',
    'brainly': 'Education',
    'photomath': 'Education',
    'mathway': 'Education',
    'grammarly': 'Education',
    'dictionary': 'Education',
    'encyclopedia': 'Education',
    'google.classroom': 'Education',
    'edmodo': 'Education',
    'byju': 'Education',

    # ── Tools / Browsers ──
    'chrome': 'Tools',
    'firefox': 'Tools',
    'opera': 'Tools',
    'brave': 'Tools',
    'uc.browser': 'Tools',
    'ucbrowser': 'Tools',
    'duckduckgo': 'Tools',
    'gmail': 'Tools',
    'outlook': 'Tools',
    'yahoo': 'Tools',
    'maps': 'Tools',
    'calculator': 'Tools',
    'clock': 'Tools',
    'calendar': 'Tools',
    'camera': 'Tools',
    'gallery': 'Tools',
    'filemanager': 'Tools',
    'files': 'Tools',
    'drive': 'Tools',
    'dropbox': 'Tools',
    'onedrive': 'Tools',
    'translate': 'Tools',
    'weather': 'Tools',
    'flashlight': 'Tools',
    'compass': 'Tools',
    'scanner': 'Tools',
    'pdf': 'Tools',
    'notepad': 'Tools',
    'notes': 'Tools',
    'reminder': 'Tools',
    'contacts': 'Tools',

    # ── Pakistan Specific ──
    'jazzcash': 'Tools',
    'easypaisa': 'Tools',
    'daraz': 'Tools',
    'foodpanda': 'Tools',
    'careem': 'Tools',
    'uber': 'Tools',
    'bykea': 'Tools',
    'ptcl': 'Tools',
    'ufone': 'Tools',
    'telenor': 'Tools',
    'zong': 'Tools',
    'mobilink': 'Tools',
    'jazz': 'Tools',
    'hbl': 'Tools',
    'meezan': 'Tools',
    'ubl': 'Tools',
    'mcb': 'Tools',
    'alfalahhbank': 'Tools',
    'pakwheels': 'Tools',
    'zameen': 'Tools',
    'olx': 'Tools',
    'imdb': 'Entertainment',
    'arynews': 'Entertainment',
    'geo': 'Entertainment',
    'samaa': 'Entertainment',
    'dawn': 'Education',
    'express': 'Entertainment',

    # ── Sensitive ──
    'vpn': 'Sensitive',
    'tor': 'Sensitive',
    'proxy': 'Sensitive',
    'hider': 'Sensitive',
    'incognito': 'Sensitive',
    'privatebrowser': 'Sensitive',
    'darkweb': 'Sensitive',
    'onion': 'Sensitive',
}
            for i, app in enumerate(usage_data):
                category = category_predictions[i]
                package  = app["package_name"]
                usage_time = app["usage_time"]

                # Override if known app
                for keyword, forced_cat in KNOWN_CATEGORIES.items():
                    if keyword in package:
                        category = forced_cat
                        break

                # ── DUPLICATE CHECK ──
                # Aaj ka same package already save hai?
                existing = models.appUsage.objects.filter(
                    child=child,
                    package_name=package,
                    date=today,
                ).first()

                if existing:
                    # Agar usage time same hai — bilkul duplicate, skip karo
                    if existing.usage_time == usage_time:
                        print(f"DUPLICATE — skipping {package}")
                        result.append({
                            "package_name": package,
                            "usage_time":   usage_time,
                            "category":     category,
                            "action":       existing.action,
                            "reasoning":    "Duplicate — already processed today",
                            "alert_message": None,
                        })
                        continue

                    # Usage time badh gayi — sirf update karo, agent mat chalao
                    if usage_time <= existing.usage_time:
                        print(f"SAME OR LESS USAGE — skipping {package}")
                        continue

                    # Agar usage time significantly badhi hai (10+ minutes) tabhi agent chalao
                    time_diff_mins = (usage_time - existing.usage_time) / 60
                    if time_diff_mins < 10:
                        print(f"MINOR INCREASE ({time_diff_mins:.1f} min) — skipping agent for {package}")
                        existing.usage_time = usage_time
                        existing.save()
                        result.append({
                            "package_name": package,
                            "usage_time":   usage_time,
                            "category":     category,
                            "action":       existing.action,
                            "reasoning":    "Minor usage update — no re-analysis",
                            "alert_message": None,
                        })
                        continue



                

                # System apps aur zero-usage apps skip karne ke liye simple rule — inhe allow kar dete hain bina agent ko involve kiye, taki unnecessary processing na ho.
                if app["usage_time"] == 0 or package in SKIP_PACKAGES:
                    result.append({
                        "package_name": package,
                        "usage_time":   app["usage_time"],
                        "category":     category,
                        "action":       "allow",
                        "reasoning":    "Skipped — system app or zero usage",
                        "alert_message": None,
                    })
                    continue
                

                # Sirf meaningful categories par agent chalao
                if category not in AGENT_CATEGORIES:
                    # Education, Tools — simple allow, no LLM needed
                    models.appUsage.objects.create(
                        child=child,
                        package_name=package,
                        usage_time=app["usage_time"],
                        category=category,
                        risk="allow",
                        action="allow",
                        date=timezone.now().date()
                    )
                    result.append({
                        "package_name": package,
                        "usage_time":   app["usage_time"],
                        "category":     category,
                        "action":       "allow",
                        "reasoning":    "Education/Tools — allowed by default",
                        "alert_message": None,
                    })
                    continue


                initial_state = {
                "package_name":   app["package_name"],
                "usage_time":     app["usage_time"],
                "ml_category":    category_predictions[i],
                "child_id":       child_id,
                

                # Baaki sab None — agent ne ye sbb data fill krna hai 
                "child_age": None, "screen_limit_mins": child.screen_time_limit,
                "usage_history": None, "recent_alerts": None,
                "total_usage_today": None, "action": None,
                "reasoning": None, "alert_message": None,
                "should_send_alert": None,
            }
                
                # thread_id = child_id — isi se memory maintain hogi per child
                # config = {"configurable": {"thread_id": f"child_{child_id}"}}
                # final = app_agent.invoke(initial_state, config=config) ## Invoking the agent with the initial state and config. Agent will process through the graph and return the final state with action, reasoning, alert message, etc.
                final = app_agent.invoke(initial_state)
                # save with prediction
                models.appUsage.objects.create(
                child=child,
                package_name=app["package_name"],
                usage_time=app["usage_time"],
                category=category_predictions[i],
                risk=final["action"],       # action hi risk hai ab
                action=final["action"],
                date=timezone.now().date()
            )
                if final["action"] == "Block" or final["action"] == "Escalate":
                    child.is_locked = True
                    child.save()

                result.append({
                    "package_name":  app["package_name"],
                    "usage_time":    app["usage_time"],
                    "category":      category_predictions[i],
                    "action":        final["action"],
                    "reasoning":     final["reasoning"],    
                    "alert_message": final["alert_message"],
                })
                print(f"App: {app['package_name']}, Category: {category_predictions[i]}, Risk: {final['action']}, Action: {final['action']},reasoning: {final['reasoning']}, Alert: {final['alert_message']}")
                
            return Response({
                "message": "Data saved successfully",
                "predictions": result
            })

        return Response(serializer.errors, status=400)
    except Exception as e:
        print("Backend error:", e)
        return Response({"error": str(e)}, status=500)

# Alerts Api (Creation + Sending)
@api_view(['POST'])
def create_alert(request):
    serializer = AlertSerializer(data=request.data)
    if serializer.is_valid():
        alert = serializer.save()
        send_alert(alert)
        return Response({"status": "alert created"})

    return Response(serializer.errors, status=400)

# Send Alert Function
def send_alert(alert):
    
    try:

       
        
       
        print("Created")
        send_mail(

            subject='Child Activity Alert ',
            message=f'alert Type {alert.alert_type}\n {alert.message}',
            from_email='22ntucs1145amnaali@gmail.com',
            recipient_list=[alert.child.parent.email],
            fail_silently=False
           
        )
        print(alert.message)
    except Exception as e:
            print("Error:", e)
            return Response({"error": f"Error sending Alert: {e}"}, status=status.HTTP_400_BAD_REQUEST)

# Decide Action based on risk level
def decide_action(risk):
    if risk == "High":
        return "Block"
    elif risk == "Medium":
        return "Warn"
    else:
        return "Allow"

# get app Risk Category
def get_risk(category):
    if category == "Sensitive":
        return "High"
    elif category in ["Social", "Games", "Entertainment"]:
        return "Medium"
    elif category in ["Education", "Tools"]:
        return "Low"
    else:
        return "Unknown"

# Parent Unlock API
@api_view(['POST'])
def unlock_device(request):
    child_id = request.data.get("child_id")
    child = models.child.objects.get(id=child_id)
    child.is_locked = False
    child.parent_unlocked = True  # ← parent ne manually unlock kiya
    child.parent_unlocked_at = timezone.now()
    child.save()
    return Response({"message": "Device Unlocked"})

# api to send data to parent app 
@api_view(['GET'])
def get_child_usage(request, child_id):
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    today = timezone.now().date()
    usage_qs = models.appUsage.objects.filter(child=child, date=today)

    # Last 2 din ka data — kal ka bhi cover ho jaye
    two_days_ago = timezone.now().date() - timedelta(days=1)
    usage_qs = models.appUsage.objects.filter(
        child=child,
        date__gte=two_days_ago  # ← today + yesterday
    )
    # Merge the duplicate package entries by taking the max usage_time and latest category
    merged = {}
    for u in usage_qs:
        pkg = u.package_name
        if pkg not in merged:
            merged[pkg] = {
                "package_name": pkg,
                "usage_time": u.usage_time,
                "category": u.category,
            }
        else:
            # Max usage time lo dono dates mein se
            if u.usage_time > merged[pkg]["usage_time"]:
                merged[pkg]["usage_time"] = u.usage_time
                merged[pkg]["category"] = u.category


    usage_data = list(merged.values())

    return Response({
        "usage_data": usage_data,
        "timestamp": timezone.now(),
    }, status=200)

# API to collect web usage data

@api_view(['POST'])
def collect_web_usage(request):
    print("Web API Called")
    print("request.body (raw):", request.body)

    serializer = WebUsageDataSerializer(data=request.data)

    if serializer.is_valid():
        
        child_id = request.data.get('child_id')
        url = request.data.get('url')

        # Removing Junk keyword 
        JUNK_KEYWORDS = ["verifying", "loading", "connecting", "about:blank", "chrome://", "..."]
        raw_url = request.data.get("url", "").lower()
        if any(kw in raw_url for kw in JUNK_KEYWORDS):
            print(f"JUNK URL rejected: {raw_url}")
            return Response({"status": "ignored"}, status=200)
        
        url = clean_url(request.data.get("url"))
        print("Cleaned URL:", url)

        if not url:
            print("IGNORED URL:", url)
            return Response({"status": "ignored"}, status=200)

        try:
            child_obj = models.child.objects.get(id=child_id)
        except models.child.DoesNotExist:
            return Response({"error": "Child not found"}, status=404)


        # Bedtime check — agar child ka bedtime chal raha hai, toh URL ko ignore kar do. Isse unnecessary alerts aur processing se bachenge.
        if is_bedtime(child_obj):
            child_obj.is_locked = True
            child_obj.save()
            return Response({"is_locked": True, "reason": "bedtime"}, status=200)
        #  DUPLICATE CHECK (same URL last 2 minute mein already save hai?)

        recent_duplicate = models.webUsage.objects.filter(
            child=child_obj,
            url=url,
            date=timezone.now().date(),
            created_at__gte=timezone.now() - timedelta(minutes=2)
        ).exists()

        if recent_duplicate:
            print(f"DUPLICATE URL — skipping: {url}")
            return Response({"status": "duplicate"}, status=200)

        print(f"Saving - Child ID: {child_id}, URL: {url}")
        prediction = web_ml_service.predict(url)

        print("WEB PREDICTION:", prediction)

        if prediction == 1:
            risk = "High"
            action = "Block"
            category = "Malicious"
        else:
            risk = "Low"
            action = "Allow"
            category = "Safe"

        # Agent baad mein risk aur action update karega
        web_obj=models.webUsage.objects.create(
        child=child_obj,
        url=url,
        usage_time=0,
        risk="Pending",
        action="Pending",
        category="Pending",
        date=timezone.now().date())
        print(f"Web usage saved - Child ID: {child_id}, URL: {url}, Risk: {risk}, Action: {action}")
        #  Agent ko background thread mein chalao
        # Warna API slow ho jayegi kyunki agent ko reasoning ke liye thoda time lag sakta hai, aur humein response jaldi dena hai taki user experience acha rahe.
        # config = {"configurable": {"thread_id": f"web_child_{child_id}"}}
        try:
            result= web_graph.invoke({"child_id":int(child_id),"url":url,"ml_prediction": prediction,"web_usage_id":  web_obj.id,})
            print(f"Agent completed for child {child_id}, url {url}, prediction {prediction},risk {risk}, action {action}")
            if result.get("action", "").lower() in ["block", "escalate"]:
                child_obj.is_locked = True
                child_obj.save()
            return Response({"status":"completed", "ml_prediction": prediction,"action":result.get("action"),"risk_level":result.get("risk_level"),"reasoning":result.get("reasoning"), }, status=200)
        except Exception as e:
            print(f"Agent Error: {traceback.format_exc()}")


            return Response({"status":"processing","ml_prediction": prediction,"message": "Agent is analyzing in background"}, status=200)

    print("SERIALIZER ERRORS:", serializer.errors)
    return Response(serializer.errors, status=400)

# URL cleaning Function

def clean_url(url):
    if not isinstance(url, str):
        return None        

    url = url.strip()

    # www. se shuru ho toh https add karo
    if url.startswith("www."):
        url = "https://" + url

    if not url.startswith(("http://", "https://")):
        return None

    if not url.startswith(("http://", "https://")):
        return None          
    try:
        parsed = urlparse(url)
    except:
        return None

    domain = parsed.netloc.lower()

    if not domain:
        return None

    if "." not in domain:
        return None

    if domain in ["localhost", "127.0.0.1"]:
        return None

    if re.search(r"\d+\.\d+[kKmM%]$", url):
        return None

    if re.fullmatch(r"\d+(\.\d+)?[kKmM%]?", domain):
        return None

    if len(domain.split(".")) < 2:
        return None

    if " " in url:
        return None

    if url.count("%") > 3:
        return None

    if len(domain) < 4:
        return None

    return url               

# Chat Analysis
# @api_view(['POST'])
# def collect_chat(request):
#     print("Chat API Called")
#     print("request.body:", request.body)

#     serializer = ChatMessageSerializer(data=request.data)

#     if not serializer.is_valid():
#         print("SERIALIZER ERRORS:", serializer.errors)
#         return Response(serializer.errors, status=400)

#     child_id  = request.data.get('child_id')
#     app_name  = request.data.get('app_name', '')
#     sender    = request.data.get('sender', 'unknown')
#     message   = request.data.get('message', '')
#     timestamp_str = request.data.get('timestamp')
#     try:
#         timestamp = make_aware(datetime.fromisoformat(timestamp_str))
#     except:
#         timestamp = timezone.now()

#     # Chote msgs ko ignore karne ke liye simple rule — agar message 3 characters se kam ka hai, toh usse process mat karo. Isse unnecessary processing aur false positives dono se bachenge.
#     if not message or len(message.strip()) < 3:
#         print("IGNORED — message too short")
#         return Response({"status": "ignored"}, status=200)

#     try:
#         child_obj = models.child.objects.get(id=child_id)
#     except models.child.DoesNotExist:
#         return Response({"error": "Child not found"}, status=404)

#     print(f"Chat — Child: {child_id} | App: {app_name} | Sender: {sender} | Msg: {message}")

#     # Duplicate message check — agar same message 2 minute ke andar repeat ho raha hai, toh usse ignore kar do. Isse accidental double sends ya app glitches se bachenge.
#     existing = models.ChatMessage.objects.filter(
#     child=child_obj,
#     app_name=app_name,
#     message=message,
#     sender=sender,
#     ).filter(
#         timestamp__gte=timezone.now() - timedelta(minutes=10)
#     ).exists()

#     if existing:
#         print("DUPLICATE — skipping")
#         return Response({"status": "duplicate"}, status=200)

   

#     # DB mein save karo
#     chat_obj = models.ChatMessage.objects.create(
#         child = child_obj,
#         app_name= app_name,
#         sender = sender,
#         message = message,
#         timestamp= timestamp,
#         category = "Pending", 
#         risk = "Pending",
#         action= "Pending",
#     )
     
#     print(f"Chat saved ID: {chat_obj.id}")
#         # ML prediction
#     try:
#         ml_category = chat_ml_service.predict(message)
#         print(f"CHAT PREDICTION: {ml_category}")

#         # DB update karo
#         chat_obj.category = ml_category

#         # Gent only for sensitive categories
#         AGENT_CATEGORIES = {"hate", "bullying", "suicide"}

#         if ml_category in AGENT_CATEGORIES:
#             print(f"SENSITIVE — invoking chat agent...")
#             try:
#                 result = chat_agent.invoke({
#                     "child_id":    int(child_id),
#                     "app_name":    app_name,
#                     "message":     message,
#                     "chat_obj_id": chat_obj.id,
#                     "ml_category": ml_category,
 
#                     # Agent ye sab khud fill karega
#                     "child_age":         None,
#                     "screen_limit_mins": None,
#                     "recent_alerts":     None,
#                     "chat_history":      None,
#                     "total_chats_today": None,
#                     "final_category":    None,
#                     "action":            None,
#                     "reasoning":         None,
#                     "risk_level":        None,
#                     "urgency":           None,
#                     "alert_message":     None,
#                     "should_send_alert": None,
#                 })
#                 print(f"AGENT DONE — action: {result['action']}, risk: {result['risk_level']}, alert: {result['alert_message']}")
#             except Exception as e:
#                 print(f"Chat Agent Error: {e}")
#                 # Fallback — ML result use karo
#                 if ml_category in ["suicide"]:
#                     chat_obj.risk   = "High"
#                     chat_obj.action = "Alert"
#                 else:
#                     chat_obj.risk   = "Medium"
#                     chat_obj.action = "Warn"
#         else:
#             # Normal — agent ki zaroorat nahi
#             chat_obj.risk   = "Low"
#             chat_obj.action = "Allow"
#             #chat_obj.save()

#         chat_obj.save()

#     except Exception as e:
#         print(f"Chat ML Error: {e}")
#         ml_category = "unknown"

#     return Response({
#         "status":   "saved",
#         "chat_id":  chat_obj.id,
#         "category": ml_category,


#     }, status=200)

# Api to deactivate child admin (jab parent chahe ki child agent temporarily deactivate ho jaye, jaise ki jab child ke saath parent khud ho, taki unnecessary alerts na aaye)
@api_view(['POST'])
@permission_classes([IsAuthenticated]) # puri tarah sure kre k deactivate krne wala parent wo hi hai jo khud log in hai 
def deactivate_child_admin(request):
    child_id = request.data.get('child_id')
    
    try:
        child = models.child.objects.get(id=child_id)
        # Command save karo database mein
        child.deactivate_command = True
        child.save()
        return Response({'status': 'command_sent'})
    except models.child.DoesNotExist:
        return Response({'status': 'error', 'message': 'Child not found'}, status=404)


# API for child agent to check if deactivate command is given by parent. Child agent is API ko periodically call karega, aur agar command milti hai toh wo apne aap ko deactivate kar dega (jaise ki alerts bhejna band kar dega) taki jab parent ke saath child ho toh unnecessary alerts na aaye.
@api_view(['GET'])
def check_deactivate_command(request):
    child_id = request.query_params.get('child_id')
    
    try:
        child = models.child.objects.get(id=child_id)
        should_deactivate = child.deactivate_command
        
        # Command mil gayi toh reset karo
        if should_deactivate:
            child.deactivate_command = False
            child.save()
            
        return Response({'deactivate': should_deactivate})
    except models.child.DoesNotExist:
        return Response({'deactivate': False})

# Chat Analysi Api
# @api_view(['POST'])
# def collect_chat(request):
#     print("Chat API Called")

#     serializer = ChatMessageSerializer(data=request.data)
#     if not serializer.is_valid():
#         return Response(serializer.errors, status=400)

#     child_id      = request.data.get('child_id')
#     app_name      = request.data.get('app_name', '')
#     sender        = request.data.get('sender', 'unknown')
#     message       = request.data.get('message', '')
#     timestamp_str = request.data.get('timestamp')

    

#     # ── FILTER 1: Too short ──
#     if not message or len(message.strip()) < 5:
#         return Response({"status": "ignored"}, status=200)

#     # ── FILTER 2: UI Noise ──
#     UI_NOISE = {
#         "voice call", "video call", "missed voice call",
#         "missed video call", "tap to call back", "no answer",
#         "call back", "photo", "video", "document", "audio",
#         "sticker", "gif", "location", "contact",
#         "this message was deleted", "you deleted this message",
#         "announcements", "explore", "missed call",
#     }
#     msg_lower = message.lower().strip()

#     if msg_lower in UI_NOISE:
#         return Response({"status": "ignored_noise"}, status=200)

#     # Date pattern
#     if re.match(r'^\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}$', msg_lower):
#         return Response({"status": "ignored_date"}, status=200)

#     if re.match(r'^\d{1,2}\s+(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{4}$', msg_lower):
#         return Response({"status": "ignored_date"}, status=200)

#     # Call duration
#     if re.match(r'^\d+\s*(sec|secs|min|mins|second|seconds|minute|minutes)$', msg_lower):
#         return Response({"status": "ignored_duration"}, status=200)

#     # Phone number
#     if re.match(r'^\+?[\d\s\-]{10,15}$', msg_lower):
#         return Response({"status": "ignored_phone"}, status=200)

#     # System messages
#     if "pinned a message" in msg_lower:
#         return Response({"status": "ignored_system"}, status=200)

#     # ── FILTER 3: Child exist ──
#     try:
#         child_obj = models.child.objects.get(id=child_id)
#     except models.child.DoesNotExist:
#         return Response({"error": "Child not found"}, status=404)

#     print(f"Chat — Child: {child_id} | App: {app_name} | Msg: {message}")

#     # ── Timestamp parse ──
#     try:
#         msg_time = make_aware(datetime.fromisoformat(timestamp_str))
#     except:
#         msg_time = timezone.now()

#     # ── FILTER 4: Purana message — historical ──
#     # WhatsApp app khulne pe poori history load karti hai
#     # Sirf last 5 minute ke messages pe agent chalao
#     time_diff = timezone.now() - msg_time
#     is_historical = time_diff.total_seconds() > 300  # 5 minutes

#     # ── FILTER 5: Duplicate ──
#     existing = models.ChatMessage.objects.filter(
#         child=child_obj,
#         app_name=app_name,
#         message=message,
#         sender=sender,
#     ).filter(
#         timestamp__gte=timezone.now() - timedelta(minutes=10)
#     ).exists()

#     if existing:
#         print("DUPLICATE — skipping")
#         return Response({"status": "duplicate"}, status=200)

#     # ── DB Save ──
#     try:
#         chat_obj = models.ChatMessage.objects.create(
#             child     = child_obj,
#             app_name  = app_name,
#             sender    = sender,
#             message   = message,
#             timestamp = msg_time,
#             category  = "historical" if is_historical else "Pending",
#             risk      = "Low"        if is_historical else "Pending",
#             action    = "Allow"      if is_historical else "Pending",
#         )
#         print(f"Chat saved ID: {chat_obj.id}")
#     except Exception as e:
#         print(f"DB Save Error: {e}")
#         return Response({"status": "db_error"}, status=200)

#     # ── Historical message — agent mat chalao ──
#     if is_historical:
#         return Response({
#             "status":  "historical",
#             "chat_id": chat_obj.id,
#         }, status=200)

#     # ── Agent Call — sirf naye messages pe ──
#     try:
#         result = chat_agent.invoke({
#             "child_id":    int(child_id),
#             "app_name":    app_name,
#             "message":     message,
#             "sender":      sender,
#             "chat_obj_id": chat_obj.id,
#             "ml_category": "none",

#             "child_age":         None,
#             "screen_limit_mins": None,
#             "recent_alerts":     None,
#             "chat_history":      None,
#             "total_chats_today": None,
#             "final_category":    None,
#             "action":            None,
#             "reasoning":         None,
#             "risk_level":        None,
#             "urgency":           None,
#             "alert_message":     None,
#             "should_send_alert": None,
#         })

#         print(f"AGENT DONE — category: {result.get('final_category')}, action: {result.get('action')}")
#         if result.get("action", "").lower() in ["block", "escalate"]:
#                 child_obj.is_locked = True
#                 child_obj.save()
#         return Response({
#             "status":    "processed",
#             "chat_id":   chat_obj.id,
#             "category":  result.get("final_category"),
#             "action":    result.get("action"),
#             "risk_level": result.get("risk_level"),
#         }, status=200)

#     except Exception as e:
#         print(f"Chat Agent Error: {traceback.format_exc()}")
#         return Response({
#             "status":  "saved",
#             "chat_id": chat_obj.id,
#         }, status=200)

# Heart beat api ----- to chech whether the app is active or not, aur last seen update karne ke liye. Child agent is API ko periodically call karega, jaise ki har 5 minute mein, taki backend ko pata rahe ki child app active hai ya nahi, aur agar child app active hai toh uska last seen timestamp update ho jaye, taki parent ko accurate information milti rahe.
@api_view(['POST'])
def heartbeat_api(request):
    child_id = request.data.get('child_id')
    try:
        child_obj = models.child.objects.get(id=child_id)
        child_obj.last_seen = timezone.now()

        child_obj.save()
        # Bedtime check — agar child ka bedtime chal raha hai, toh device ko lock kar do. Isse unnecessary alerts aur processing se bachenge.
        if is_bedtime(child_obj):
                child_obj.is_locked = True
                child_obj.save()
                return Response({"is_locked": True, "reason": "bedtime"}, status=200)
        return Response({"status": "ok"}, status=200)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)


# API for child agent to check if device is locked by parent. Child agent is API ko periodically call karega, jaise ki har 5 minute mein, taki agar parent ne device lock kar diya hai toh child app ko pata chal jaye aur wo apne aap ko lock kar le.


@api_view(['GET'])
def check_lock_status(request):
    child_id = request.query_params.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)

        # Bedtime always wins
        if is_bedtime(child):
            child.is_locked = True
            child.parent_unlocked = False
            child.parent_unlocked_at = None
            child.save()
            return Response({"is_locked": True, "reason": "bedtime"}, status=200)

        # Grace period check — time-based (30 min from unlock time)
        if child.parent_unlocked and child.parent_unlocked_at:
            elapsed = timezone.now() - child.parent_unlocked_at
            if elapsed.total_seconds() < 30 * 60:
                # Grace period mein hai — lock mat karo
                return Response({"is_locked": False})
            else:
                # 30 min guzar gaye — grace khatam, reset karo
                child.parent_unlocked = False
                child.parent_unlocked_at = None
                child.save()

        # Normal usage check
        today = timezone.now().date()
        existing_usage = models.appUsage.objects.filter(child=child, date=today)
        merged = {}
        for u in existing_usage:
            pkg = u.package_name
            if pkg not in merged or u.usage_time > merged[pkg]:
                merged[pkg] = u.usage_time
        total_usage_today = sum(merged.values())
        screen_limit_seconds = child.screen_time_limit * 60

        print(f"Lock check — used: {total_usage_today}s, limit: {screen_limit_seconds}s")

        if total_usage_today >= screen_limit_seconds:
            child.is_locked = True
            child.save()
            return Response({"is_locked": True, "reason": "screen_limit"}, status=200)

        # Usage limit cross nahi hui, unlock karo agar locked tha
        if child.is_locked:
            child.is_locked = False
            child.save()

        return Response({"is_locked": child.is_locked})
    except models.child.DoesNotExist:
        return Response({"is_locked": False})
    
# api to lock the device from child side, jab ML model ya agent detect kare ki risky activity ho rahi hai, toh wo device ko lock karne ke liye is API ko call karega, taki parent ko pata chal jaye ki risky activity detect hui hai, aur device lock bhi ho jaye taki child uss activity ko continue na kar sake. Is API ko call karne se DB mein is_locked=True save hoga, taki checkLockStatus() API reboot ke baad bhi correct status return kare.

@api_view(['POST'])
def lock_device(request):
    """
    Called by the child app's lockDevice() whenever the app/ML triggers a lock.
    Persists is_locked=True to DB so checkLockStatus() restores it after reboot.
    """
    child_id = request.data.get('child_id')
    if not child_id:
        return Response({"error": "child_id required"}, status=400)
    try:
        child = models.child.objects.get(id=child_id)
        child.is_locked = True
        child.save()
        return Response({"status": "locked"}, status=200)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)


# APi to collect chat messages from child app. Jab bhi child app mein koi naya chat message detect hota hai, chahe wo WhatsApp ho, Messenger ho, ya koi aur chat app, toh wo is API ko call karega message details ke saath, taki backend us message ko analyze kar sake risk ke liye, aur agar zarurat pade toh parent ko alert bhej sake. Is API mein hum kuch basic filters bhi laga sakte hain jaise ki chote messages ko ignore karna, ya system messages ko ignore karna, taki unnecessary processing na ho.
# @api_view(['POST'])
# def collect_chat(request):
#     print("Chat API Called")

#     serializer = ChatMessageSerializer(data=request.data)
#     if not serializer.is_valid():
#         return Response(serializer.errors, status=400)

#     child_id      = request.data.get('child_id')
#     app_name      = request.data.get('app_name', '')
#     sender        = request.data.get('sender', 'unknown')
#     message       = request.data.get('message', '')
#     timestamp_str = request.data.get('timestamp')

#     # ── FILTER 1: Too short ──
#     if not message or len(message.strip()) < 5:
#         return Response({"status": "ignored"}, status=200)

#     # ── FILTER 2: UI Noise ──
#     UI_NOISE = {
#         "voice call", "video call", "missed voice call",
#         "missed video call", "tap to call back", "no answer",
#         "call back", "photo", "video", "document", "audio",
#         "sticker", "gif", "location", "contact",
#         "this message was deleted", "you deleted this message",
#         "announcements", "explore", "missed call",
#     }
#     msg_lower = message.lower().strip()

#     if msg_lower in UI_NOISE:
#         return Response({"status": "ignored_noise"}, status=200)

#     if re.match(r'^\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}$', msg_lower):
#         return Response({"status": "ignored_date"}, status=200)

#     if re.match(r'^\d{1,2}\s+(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{4}$', msg_lower):
#         return Response({"status": "ignored_date"}, status=200)

#     if re.match(r'^\d+\s*(sec|secs|min|mins|second|seconds|minute|minutes)$', msg_lower):
#         return Response({"status": "ignored_duration"}, status=200)

#     if re.match(r'^\+?[\d\s\-]{10,15}$', msg_lower):
#         return Response({"status": "ignored_phone"}, status=200)

#     if "pinned a message" in msg_lower:
#         return Response({"status": "ignored_system"}, status=200)

#     # ── FILTER 3: Child exist ──
#     try:
#         child_obj = models.child.objects.get(id=child_id)
#     except models.child.DoesNotExist:
#         return Response({"error": "Child not found"}, status=404)

#     print(f"Chat — Child: {child_id} | App: {app_name} | Msg: {message}")

#     if is_bedtime(child_obj):
#         child_obj.is_locked = True
#         child_obj.save()
#         return Response({"is_locked": True, "reason": "bedtime"}, status=200)

#     # ── Timestamp parse ──
#     try:
#         msg_time = make_aware(datetime.fromisoformat(timestamp_str))
#     except:
#         msg_time = timezone.now()

#     # ── FILTER 4: Historical ──
#     time_diff = timezone.now() - msg_time
#     is_historical = time_diff.total_seconds() > 300

#     # ── FILTER 5: Duplicate ──
#     existing = models.ChatMessage.objects.filter(
#         child=child_obj,
#         app_name=app_name,
#         message=message,
#         sender=sender,
#     ).filter(
#         timestamp__gte=timezone.now() - timedelta(minutes=10)
#     ).exists()

#     if existing:
#         print("DUPLICATE — skipping")
#         return Response({"status": "duplicate"}, status=200)

#     # ── DB Save ──
#     try:
#         chat_obj = models.ChatMessage.objects.create(
#             child     = child_obj,
#             app_name  = app_name,
#             sender    = sender,
#             message   = message,
#             timestamp = msg_time,
#             category  = "historical" if is_historical else "Pending",
#             risk      = "Low"        if is_historical else "Pending",
#             action    = "Allow"      if is_historical else "Pending",
#         )
#         print(f"Chat saved ID: {chat_obj.id}")
#     except Exception as e:
#         print(f"DB Save Error: {e}")
#         return Response({"status": "db_error"}, status=200)

#     # ── Historical message — agent mat chalao ──
#     if is_historical:
#         return Response({
#             "status":  "historical",
#             "chat_id": chat_obj.id,
#         }, status=200)

#     # ── ML Prediction (ML + Groq verification for sensitive) ──
#     try:
#         ml_category = chat_ml_service.predict(message)
#     except Exception as e:
#         print(f"Chat ML Error: {e}")
#         ml_category = "normal"

#     print(f"FINAL ML CATEGORY: {ml_category}")

#     # ── Fast-path: normal messages ──
#     if ml_category == "normal":
#         chat_obj.category = "normal"
#         chat_obj.risk     = "Low"
#         chat_obj.action   = "Allow"
#         chat_obj.save()
#         return Response({
#             "status":   "processed",
#             "chat_id":  chat_obj.id,
#             "category": "normal",
#             "action":   "Allow"
#         }, status=200)

#     # ── Sensitive (hate/bullying/suicide) → LLM agent for nuanced action ──
#     try:
#         result = chat_agent.invoke({
#             "child_id":    int(child_id),
#             "app_name":    app_name,
#             "message":     message,
#             "sender":      sender,
#             "chat_obj_id": chat_obj.id,
#             "ml_category": ml_category,

#             "child_age":         None,
#             "screen_limit_mins": None,
#             "recent_alerts":     None,
#             "chat_history":      None,
#             "total_chats_today": None,
#             "final_category":    None,
#             "action":            None,
#             "reasoning":         None,
#             "risk_level":        None,
#             "urgency":           None,
#             "alert_message":     None,
#             "should_send_alert": None,
#         })

#         print(f"AGENT DONE — category: {result.get('final_category')}, action: {result.get('action')}")
#         if result.get("action", "").lower() in ["block", "escalate"]:
#             child_obj.is_locked = True
#             child_obj.save()

#         return Response({
#             "status":     "processed",
#             "chat_id":    chat_obj.id,
#             "category":   result.get("final_category", ml_category),
#             "action":     result.get("action"),
#             "risk_level": result.get("risk_level"),
#         }, status=200)

#     except Exception as e:
#         print(f"Chat Agent Error: {traceback.format_exc()}")
#         # Fallback agar agent fail ho jaye
#         if ml_category == "suicide":
#             chat_obj.risk, chat_obj.action = "High", "Escalate"
#             child_obj.is_locked = True
#             child_obj.save()
#         else:
#             chat_obj.risk, chat_obj.action = "Medium", "Warn"
#         chat_obj.category = ml_category
#         chat_obj.save()
#         return Response({
#             "status":   "saved",
#             "chat_id":  chat_obj.id,
#             "category": ml_category,
#             "action":   chat_obj.action,
#         }, status=200)

@api_view(['POST'])
def collect_chat(request):
    print("Chat API Called")

    serializer = ChatMessageSerializer(data=request.data)
    if not serializer.is_valid():
        return Response(serializer.errors, status=400)

    child_id      = request.data.get('child_id')
    app_name      = request.data.get('app_name', '')
    sender        = request.data.get('sender', 'unknown')
    message       = request.data.get('message', '')
    timestamp_str = request.data.get('timestamp')

    is_content = (sender == "content")

    # ── FILTER 1: Too short ──
    min_len = 5 if not is_content else 4
    if not message or len(message.strip()) < min_len:
        return Response({"status": "ignored"}, status=200)

    # ── FILTER 2: UI Noise — sirf chat ke liye ──
    if not is_content:
        UI_NOISE = {
            "voice call", "video call", "missed voice call",
            "missed video call", "tap to call back", "no answer",
            "call back", "photo", "video", "document", "audio",
            "sticker", "gif", "location", "contact",
            "this message was deleted", "you deleted this message",
            "announcements", "explore", "missed call",
        }
        msg_lower = message.lower().strip()

        if msg_lower in UI_NOISE:
            return Response({"status": "ignored_noise"}, status=200)
        
        if is_content:
                CONTENT_NOISE = {"like", "save", "share", "comment", "subscribe", "follow",
    "more", "less", "ad", "sponsored", "shorts", "summary",
    "music", "play", "news", "gaming", "months", "learning",
    "fashion", "beauty", "podcasts", "live", "explore",
    "youtube playables", "instant games, no downloads",
    "breaking news", "television series", "weather forecasting",
    "pakistani dramas", "cricket highlights", "fitness workouts", "cooking recipes",
    "travel vlogs", "unboxing videos", "technology reviews", "educational content", "comedy sketches", "music videos",}
                if message.lower().strip() in CONTENT_NOISE:
                    return Response({"status": "ignored_noise"}, status=200)

        if re.match(r'^\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}$', msg_lower):
            return Response({"status": "ignored_date"}, status=200)

        if re.match(r'^\d{1,2}\s+(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{4}$', msg_lower):
            return Response({"status": "ignored_date"}, status=200)

        if re.match(r'^\d+\s*(sec|secs|min|mins|second|seconds|minute|minutes)$', msg_lower):
            return Response({"status": "ignored_duration"}, status=200)

        if re.match(r'^\+?[\d\s\-]{10,15}$', msg_lower):
            return Response({"status": "ignored_phone"}, status=200)

        if "pinned a message" in msg_lower:
            return Response({"status": "ignored_system"}, status=200)

    # ── FILTER 3: Child exist ──
    try:
        child_obj = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    print(f"Chat — Child: {child_id} | App: {app_name} | Sender: {sender} | Msg: {message}")

    if is_bedtime(child_obj):
        child_obj.is_locked = True
        child_obj.save()
        return Response({"is_locked": True, "reason": "bedtime"}, status=200)

    # ── Timestamp parse ──
    try:
        msg_time = make_aware(datetime.fromisoformat(timestamp_str))
    except:
        msg_time = timezone.now()

    # ── FILTER 4: Historical — sirf chat ke liye strict, content ke liye relaxed ──
    time_diff = timezone.now() - msg_time
    if is_content:
        is_historical = False  # content ko ALWAYS analyze karo, historical skip mat karo
    else:
        is_historical = time_diff.total_seconds() > 300

    # ── FILTER 5: Duplicate ──
    dup_window = timedelta(minutes=10) if not is_content else timedelta(minutes=30)
    existing = models.ChatMessage.objects.filter(
        child=child_obj,
        app_name=app_name,
        message=message,
        sender=sender,
    ).filter(
        timestamp__gte=timezone.now() - dup_window
    ).exists()

    if existing:
        print("DUPLICATE — skipping")
        return Response({"status": "duplicate"}, status=200)

    # ── DB Save ──
    try:
        chat_obj = models.ChatMessage.objects.create(
            child     = child_obj,
            app_name  = app_name,
            sender    = sender,
            message   = message,
            timestamp = msg_time,
            category  = "historical" if is_historical else "Pending",
            risk      = "Low"        if is_historical else "Pending",
            action    = "Allow"      if is_historical else "Pending",
        )
        print(f"Chat saved ID: {chat_obj.id}")
    except Exception as e:
        print(f"DB Save Error: {e}")
        return Response({"status": "db_error"}, status=200)

    if is_historical:
        return Response({"status": "historical", "chat_id": chat_obj.id}, status=200)

    # ── Content ke liye seedha agent (ML skip — ML chat-trained hai, content pe accurate nahi) ──
    if is_content:
        ml_category = "content"
    else:
        try:
            ml_category = chat_ml_service.predict(message)
        except Exception as e:
            print(f"Chat ML Error: {e}")
            ml_category = "normal"

        print(f"FINAL ML CATEGORY: {ml_category}")

        # Fast-path: normal chat messages
        if ml_category == "normal":
            chat_obj.category = "normal"
            chat_obj.risk     = "Low"
            chat_obj.action   = "Allow"
            chat_obj.save()
            return Response({
                "status": "processed", "chat_id": chat_obj.id,
                "category": "normal", "action": "Allow"
            }, status=200)

    # ── Agent invoke (chat ke liye sensitive cases, content ke liye sab) ──
    try:
        result = chat_agent.invoke({
            "child_id":    int(child_id),
            "app_name":    app_name,
            "message":     message,
            "sender":      sender,
            "chat_obj_id": chat_obj.id,
            "ml_category": ml_category,
            "content_type": "content" if is_content else "chat",  # NAYA

            "child_age":         None,
            "screen_limit_mins": None,
            "recent_alerts":     None,
            "chat_history":      None,
            "total_chats_today": None,
            "final_category":    None,
            "action":            None,
            "reasoning":         None,
            "risk_level":        None,
            "urgency":           None,
            "alert_message":     None,
            "should_send_alert": None,
        })

        print(f"AGENT DONE — category: {result.get('final_category')}, action: {result.get('action')}")
        if result.get("action", "").lower() in ["block", "escalate"]:
            child_obj.is_locked = True
            child_obj.save()

        return Response({
            "status":     "processed",
            "chat_id":    chat_obj.id,
            "category":   result.get("final_category", ml_category),
            "action":     result.get("action"),
            "risk_level": result.get("risk_level"),
        }, status=200)

    except Exception as e:
        print(f"Chat Agent Error: {traceback.format_exc()}")
        if ml_category == "suicide":
            chat_obj.risk, chat_obj.action = "High", "Escalate"
            child_obj.is_locked = True
            child_obj.save()
        else:
            chat_obj.risk, chat_obj.action = "Medium", "Warn"
        chat_obj.category = ml_category
        chat_obj.save()
        return Response({
            "status": "saved", "chat_id": chat_obj.id,
            "category": ml_category, "action": chat_obj.action,
        }, status=200)



# Api to send data on dashboard home page, jaha parent ko child ki summary dikhani hai, jaise ki total screen time, app usage summary, YouTube usage, blocked websites, suspicious chats, etc. Taaki parent ko ek quick overview mil jaye child ki activities ka, bina alag alag APIs call kiye.


@api_view(['GET'])
def dashboard_summary_api(request):
    child_id = request.query_params.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    today = timezone.now().date()
    two_days_ago = today - timedelta(days=1)

    # Screen time = total of ALL apps (last 2 days, max per app)
    all_usage = models.appUsage.objects.filter(
        child=child,
        date__gte=two_days_ago
    )

    # Same package ki duplicate entries merge karo — max lo
    merged = {}
    for u in all_usage:
        pkg = u.package_name
        if pkg not in merged or u.usage_time > merged[pkg]:
            merged[pkg] = u.usage_time

    total_screen_time = sum(merged.values())

    # App usage = sirf social/entertainment/gaming apps (non-system)
    SKIP_KEYWORDS = [
        'android', 'samsung', 'launcher', 'dialer',
        'calculator', 'permissioncontroller', 'bixby',
        'systemui', 'inputmethod', 'com.example',
    ]
    SKIP_PACKAGES = {
        'cn.wps.moffice_eng',
        'com.google.android.googlequicksearchbox',
        'com.samsung.android.incallui',
        'com.sec.android.gallery3d',
        'com.samsung.accessibility',
        'com.android.settings',
        'com.techlogix.mobilinkcustomer',
    }

    app_usage_time = 0
    for pkg, usage in merged.items():
        pkg_lower = pkg.lower()
        if pkg_lower in SKIP_PACKAGES:
            continue
        if any(kw in pkg_lower for kw in SKIP_KEYWORDS):
            continue
        app_usage_time += usage

    # # YouTube
    # youtube_entries = {
    #     pkg: usage for pkg, usage in merged.items()
    #     if 'youtube' in pkg.lower()
    # }
    # youtube_count = len(youtube_entries)
    # last_youtube_pkg = models.appUsage.objects.filter(
    #     child=child, package_name__icontains='youtube'
    # ).order_by('-created_at').first()

        # Latest YouTube content (title)
    latest_youtube_content = models.ChatMessage.objects.filter(
        child=child,
        app_name="YouTube",
        sender="content"
    ).order_by('-created_at').first()

    # Flagged YouTube content count (last 7 days)
    flagged_youtube_count = models.ChatMessage.objects.filter(
        child=child,
        app_name="YouTube",
        sender="content",
        created_at__gte=timezone.now() - timedelta(days=7)
    ).exclude(action__in=['Allow', 'allow']).count()

    # Blocked sites
    blocked_sites = models.webUsage.objects.filter(
        child=child, date=today, action='Block'
    )
    blocked_count = blocked_sites.count()
    last_blocked = blocked_sites.order_by('-created_at').first()

    # Latest chat alert
    latest_chat_alert = models.ChatMessage.objects.filter(
        child=child
    ).exclude(action='Allow').order_by('-created_at').first()

    return Response({
        "screen_time_seconds": total_screen_time,   # ← sab apps ka total
        "screen_time_limit": child.screen_time_limit,
        "app_usage_seconds": app_usage_time,         # ← sirf user apps
        # "youtube_count": youtube_count,
        # "last_youtube": last_youtube_pkg.package_name if last_youtube_pkg else None,
        "last_youtube_content": latest_youtube_content.message if latest_youtube_content else None,  
        "youtube_content_category": latest_youtube_content.category if latest_youtube_content else None,  
        "flagged_youtube_count": flagged_youtube_count, 
            "blocked_sites_count": blocked_count,
        "last_blocked_url": last_blocked.url if last_blocked else None,
        "latest_chat_alert": {
            "title": "Suspicious Chat Detected",
            "sender": latest_chat_alert.sender,
            "message": latest_chat_alert.message,
            "category": latest_chat_alert.category,
            "time": latest_chat_alert.created_at,
        } if latest_chat_alert else None,
    }, status=200)

# API for browsing monitoring page, jaha parent ko detailed list dikhani hai child ke web activities ki, jaise ki kaun kaun se websites visit kiye, unpe kitna time spend kiya, kaun se websites block hue, etc. Taaki parent ko pata chal jaye ki child kis type ke websites visit kar raha hai, aur agar koi risky website visit ho rahi hai toh uske baare mein bhi information mil jaye.
@api_view(['GET'])
def browsing_monitoring_api(request):
    child_id = request.query_params.get('child_id')
    filter_type = request.query_params.get('filter', 'today')  # today / week / month

    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    today = timezone.now().date()
    if filter_type == 'week':
        start_date = today - timedelta(days=7)
    elif filter_type == 'month':
        start_date = today - timedelta(days=30)
    else:
        start_date = today

    web_records = models.webUsage.objects.filter(
        child=child, date__gte=start_date
    ).order_by('-created_at')

    web_list = [{
        "title": w.url,
        "time_spent": w.usage_time,
        "category": w.category,
        "blocked": w.action == 'Block',
        "reasoning": w.reasoning,
    } for w in web_records]

    # Safety alerts
    alerts = models.Alert.objects.filter(child=child, source="web").order_by('-created_at')[:10]
    alert_list = [{
        "alert_type": a.alert_type,
        "message": a.message,
        "created_at": a.created_at,
    } for a in alerts]

    return Response({
        "browsing": web_list,
        "alerts": alert_list,
    }, status=200)


# APi to fetch alerts for alerts page, jaha parent ko chronological list dikhani hai child ke safety alerts ki, jaise ki risky websites visit karna, suspicious chats, screen time limit cross karna, etc. Taaki parent ko ek clear timeline mil jaye child ke risky activities ka, aur wo un alerts ko click karke unke details bhi dekh sake.
@api_view(['GET'])
def fetchAlerts_api(request):
    child_id = request.query_params.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    alerts = models.Alert.objects.filter(child=child).order_by('-created_at')[:20]

    data = [{
        "id": a.id,
        "alert_type": a.alert_type,
        "source": a.source,
        "message": a.message,
        "created_at": a.created_at,
    } for a in alerts]

    return Response({
        "child": {
            "name": f"{child.firstname} {child.lastname}",
            "age": child.age
        },
        "alerts": data
    }, status=200)


## Api alerts related to device status, jaise ki accessibility permission off hona, device admin disable hona, etc. Jab bhi child app detect kare ki koi important monitoring permission disable hui hai, toh wo is API ko call karega taki parent ko alert bheja ja sake ki device ki monitoring compromised ho sakti hai, aur wo apne child se keh sake ki wo us permission ko jaldi se re-enable kar de.
@api_view(['POST'])
def report_device_status(request):
    """
    Child app calls this when it detects:
    - accessibility permission turned off
    - device admin/monitoring disabled by user
    """
    child_id = request.data.get('child_id')
    status_type = request.data.get('status_type')  # 'accessibility_off' / 'admin_disabled'

    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    # Duplicate check — same status alert in last 30 mins
    recent = models.Alert.objects.filter(
        child=child,
        alert_type=status_type,
        source="device",
        created_at__gte=timezone.now() - timedelta(minutes=30)
    ).exists()

    if recent:
        return Response({"status": "duplicate"}, status=200)

    messages = {
        "accessibility_off": "Accessibility permission has been turned off on your child's device. Monitoring features like app and web tracking may not work correctly. Please ask your child to re-enable it.",
        "admin_disabled": "Device admin / monitoring has been disabled on your child's device. The app can no longer enforce locks or restrictions until it's re-enabled.",
    }

    message = messages.get(status_type, "A monitoring permission was disabled on your child's device.")

    alert_obj = models.Alert.objects.create(
        child=child,
        alert_type=status_type,
        source="device",
        message=message,
    )

    # reuse send_alert from views.py
    send_alert(alert_obj)

    return Response({"status": "alert created"}, status=200)


# GET - fetch current limits + category usage (for display only)
@api_view(['GET'])
def get_screen_limits(request):
    child_id = request.query_params.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    today = timezone.now().date()

    # Sirf aaj ka data — categories aur total usage ke liye
    usage_qs = models.appUsage.objects.filter(child=child, date=today)
    merged = {}
    for u in usage_qs:
        pkg = u.package_name
        if pkg not in merged or u.usage_time > merged[pkg]["usage_time"]:
            merged[pkg] = {"usage_time": u.usage_time, "category": u.category}

    category_usage = {"Social": 0, "Entertainment": 0, "Games": 0}
    for data in merged.values():
        cat = data["category"]
        if cat in category_usage:
            category_usage[cat] += data["usage_time"]

    total_usage = sum(v["usage_time"] for v in merged.values())

    return Response({
        "screen_time_limit": child.screen_time_limit,
        "total_usage_seconds": total_usage,
        "bedtime_start": str(child.bedtime_start) if child.bedtime_start else None,
        "bedtime_end": str(child.bedtime_end) if child.bedtime_end else None,
        "category_usage_seconds": category_usage,
        'bedtime_enabled': child.bedtime_enabled,
    }, status=200)

# POST - update overall limit + bedtime
@api_view(['POST'])
def update_screen_limits(request):
    child_id = request.data.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    if 'screen_time_limit' in request.data:
        child.screen_time_limit = request.data['screen_time_limit']

    if 'bedtime_start' in request.data:
        child.bedtime_start = request.data['bedtime_start']

    if 'bedtime_end' in request.data:
        child.bedtime_end = request.data['bedtime_end']

    if 'bedtime_enabled' in request.data:
        child.bedtime_enabled = request.data['bedtime_enabled']

    child.save()

    # Auto-unlock check — agar naya limit set hone ke baad usage limit se kam hai
    # aur bedtime active nahi hai, to lock hata do
    if child.is_locked and not is_bedtime(child):
        two_days_ago = timezone.now().date() - timedelta(days=1)
        existing_usage = models.appUsage.objects.filter(child=child, date__gte=two_days_ago)
        merged_existing = {}
        for u in existing_usage:
            pkg = u.package_name
            if pkg not in merged_existing or u.usage_time > merged_existing[pkg]:
                merged_existing[pkg] = u.usage_time
        total_usage_today = sum(merged_existing.values())

        screen_limit_seconds = child.screen_time_limit * 60

        if total_usage_today < screen_limit_seconds:
            child.is_locked = False
            child.save()

    return Response({"status": "updated", "is_locked": child.is_locked}, status=200)

# Function to check bedtime status for a child. Agar current time bedtime range mein hai, toh True return karega, warna False. Bedtime range ko handle karte waqt overnight ranges (jaise 21:00 - 07:00) ko bhi consider kiya gaya hai.


def is_bedtime(child):
    if not child.bedtime_enabled or not child.bedtime_start or not child.bedtime_end:
        return False
    
    now = timezone.localtime().time()
    
    # String ho sakti hai ya time object — dono handle karo
    start = child.bedtime_start
    end = child.bedtime_end
    
    if isinstance(start, str):
        parts = start.split(':')
        start = dt_time(int(parts[0]), int(parts[1]))
    
    if isinstance(end, str):
        parts = end.split(':')
        end = dt_time(int(parts[0]), int(parts[1]))
    
    if start <= end:
        return start <= now <= end
    else:  # overnight, e.g. 21:00 - 07:00
        return now >= start or now <= end


# API to fetch chat messages
@api_view(['GET'])
def fetch_chat_messages(request):
    child_id = request.query_params.get('child_id')
    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    # Flagged chats — jo allow nahi hain, aur content exclude karo
    flagged = models.ChatMessage.objects.filter(
        child=child
    ).exclude(
        action__in=['Allow', 'allow', 'historical']
    ).exclude(
        sender="content"   
    ).order_by('-created_at')[:20]

    # Stats
    today = timezone.now().date()
    total_today = models.ChatMessage.objects.filter(
        child=child,
        timestamp__date=today
    ).exclude(sender="content").count()   

    total_all = models.ChatMessage.objects.filter(
        child=child
    ).exclude(sender="content").count()  

    safe_count = models.ChatMessage.objects.filter(
        child=child,
        action__in=['Allow', 'allow']
    ).exclude(sender="content").count()   

    flagged_data = [{
        "id": m.id,
        "app_name": m.app_name,
        "sender": m.sender or "Unknown",
        "message": m.message,
        "category": m.category or "unknown",
        "risk": m.risk or "Low",
        "action": m.action or "Allow",
        "time": m.created_at,
    } for m in flagged]

    # Safety alerts — chat se
    alerts = models.Alert.objects.filter(
        child=child,
        source="chat"
    ).order_by('-created_at')[:10]

    alert_data = [{
        "alert_type": a.alert_type,
        "message": a.message,
        "created_at": a.created_at,
    } for a in alerts]

    return Response({
        "stats": {
            "total_today": total_today,
            "total_all": total_all,
            "safe_count": safe_count,
        },
        "flagged_chats": flagged_data,
        "safety_alerts": alert_data,
    }, status=200)

## Youtube Api
@api_view(['GET'])
def youtube_activity_api(request):
    child_id = request.query_params.get('child_id')
    filter_type = request.query_params.get('filter', 'today')  # today / week / month

    try:
        child = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    today = timezone.now().date()
    if filter_type == 'week':
        start_date = today - timedelta(days=7)
    elif filter_type == 'month':
        start_date = today - timedelta(days=30)
    else:
        start_date = today

    # History: YouTube content messages 
    history_qs = models.ChatMessage.objects.filter(
        child=child,
        app_name="YouTube",
        sender="content",
        timestamp__date__gte=start_date,
    ).order_by('-created_at')[:30]

    history_data = []
    for m in history_qs:
        time_diff = timezone.now() - m.created_at
        mins = int(time_diff.total_seconds() // 60)
        if mins < 60:
            time_ago = f"{mins} min ago"
        elif mins < 1440:
            time_ago = f"{mins // 60}h ago"
        else:
            time_ago = f"{mins // 1440}d ago"

        history_data.append({
            "id": m.id,
            "title": m.message,
            "category": m.category or "Unknown",
            "is_flagged": m.action not in ['Allow', 'allow'],
            "risk": m.risk or "Low",
            "time_ago": time_ago,
            "timestamp": m.created_at,
        })

    #  Stats 
    total_videos = models.ChatMessage.objects.filter(
        child=child, app_name="YouTube", sender="content",
        timestamp__date__gte=start_date,
    ).count()

    flagged_count = models.ChatMessage.objects.filter(
        child=child, app_name="YouTube", sender="content",
        timestamp__date__gte=start_date,
    ).exclude(action__in=['Allow', 'allow']).count()

    # Category Breakdown 
    all_content = models.ChatMessage.objects.filter(
        child=child, app_name="YouTube", sender="content",
        timestamp__date__gte=start_date,
    )
    category_map = {}
    for m in all_content:
        cat = m.category or "Unknown"
        category_map[cat] = category_map.get(cat, 0) + 1

    total_cat = sum(category_map.values()) or 1
    categories = [
        {"name": k, "count": v, "percent": round((v / total_cat) * 100)}
        for k, v in category_map.items()
    ]

    # Watch time (YouTube app usage) - last 2 days, max per day
    youtube_usage = models.appUsage.objects.filter(
        child=child,
        package_name__icontains='youtube',
        date__gte=start_date,
    ).order_by('date')

    watch_time_by_day = {}
    for u in youtube_usage:
        d = str(u.date)
        if d not in watch_time_by_day or u.usage_time > watch_time_by_day[d]:
            watch_time_by_day[d] = u.usage_time

    total_watch_seconds = sum(watch_time_by_day.values())

    #  Last watched 
    last = models.ChatMessage.objects.filter(
        child=child, app_name="YouTube", sender="content"
    ).order_by('-created_at').first()

    # Safety Alerts
    alerts = models.Alert.objects.filter(
        child=child,
    ).filter(
        Q(source='youtube') | Q(message__icontains='youtube')
    ).order_by('-created_at')[:10]

    alert_data = [{
        "id": a.id,
        "alert_type": a.alert_type,
        "message": a.message,
        "created_at": a.created_at,
    } for a in alerts]

    return Response({
        "child": {
            "name": f"{child.firstname} {child.lastname}",
            "age": child.age,
        },
        "stats": {
            "total_videos": total_videos,
            "flagged_count": flagged_count,
            "total_watch_seconds": total_watch_seconds,
            "watch_time_by_day": watch_time_by_day,
        },
        "last_watched": {
            "title": last.message if last else None,
            "category": last.category if last else None,
            "is_flagged": last.action not in ['Allow', 'allow'] if last else False,
        } if last else None,
        "history": history_data,
        "categories": categories,
        "alerts": alert_data,
    }, status=200)


## Api to fetch profile data
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_profile_api(request):
    user = request.user
    profile, _ = models.ParentProfile.objects.get_or_create(user=user)
    return Response({
        "username": user.username,
        "email":    user.email,
        "phone":    profile.phone or "",
    }, status=200)

# update profile api, jisme parent apna username, password aur phone number update kar sakta hai. Agar username already taken hai toh error return karega. Password change hone ke baad naya JWT token generate hoga taki user ko dobara login na karna pade.
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_profile_api(request):
    serializer = UpdateProfileSerializer(data=request.data)
    if not serializer.is_valid():
        return Response({"errors": serializer.errors}, status=400)

    user = request.user

    if 'username' in serializer.validated_data and serializer.validated_data['username']:
        new_username = serializer.validated_data['username']
        if User.objects.filter(username=new_username).exclude(id=user.id).exists():
            return Response({"error": "Username already taken."}, status=400)
        user.username = new_username

    if 'password' in serializer.validated_data and serializer.validated_data['password']:
        user.set_password(serializer.validated_data['password'])

    user.save()

    phone = serializer.validated_data.get('phone', '')
    profile, _ = models.ParentProfile.objects.get_or_create(user=user)
    profile.phone = phone
    profile.save()

    # Password change ke baad naya token generate karo
    refresh = RefreshToken.for_user(user)
    return Response({
        "message": "Profile updated successfully",
        "tokens": {
            "refresh": str(refresh),
            "access":  str(refresh.access_token),
        }
    }, status=200)