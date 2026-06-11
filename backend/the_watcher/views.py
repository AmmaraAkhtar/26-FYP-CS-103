from xml.parsers.expat import model

from django.shortcuts import render
from . serializers import ParentSerializer,OtpSerializer,PasswordResetSerializer,WebUsageDataSerializer,LoginSerializer,ChildSerializer,PairingCodeSerializer,PairedChildSerializer,AppUsageSerializer,AlertSerializer,ChatMessageSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import api_view,permission_classes
from django.contrib.auth import authenticate
import random
from . import models
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
        child = models.child.objects.create(firstname=firstname, lastname=lastname, age=age, screen_time_limit=screen_time_limit,parent = user,pairingCode=pairing_code)
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
            SKIP_PACKAGES = {
    'com.android', 'android',
    'com.samsung.android.app.galaxyfinder',
    'com.samsung.android.bixby.agent',
    'com.google.android.permissioncontroller',
    'com.sec.android.app.launcher',
    'com.samsung.android.dialer',
}
            AGENT_CATEGORIES = {"Social", "Sensitive", "Games", "Entertainment"}

            for i, app in enumerate(usage_data):
                category = category_predictions[i]
                package  = app["package_name"]
                usage_time = app["usage_time"]

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
                        date=validated_data["timestamp"].date()
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
                "child_age": None, "screen_limit_mins": None,
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
                date=validated_data["timestamp"].date()
            )

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
    child.save()

    return Response({
        "message": "Device Unlocked"
    })

# api to send data to parent app 
@api_view(['GET'])
def get_child_usage(request, child_id):
    # Last saved usage data return karo
    usage = models.appUsage.objects.filter(child_id=child_id).last()
    if usage:
        return Response({
            "usage_data": usage.usage_data,
            "timestamp": usage.timestamp,
            "total_screen_time": usage.total_screen_time
        })
    return Response({"error": "No data found"}, status=404)

# API to collect web usage data

@api_view(['POST'])
def collect_web_usage(request):
    print("Web API Called")
    print("request.body (raw):", request.body)

    serializer = WebUsageDataSerializer(data=request.data)

    if serializer.is_valid():
        
        child_id = request.data.get('child_id')
        url = request.data.get('url')
        url = clean_url(request.data.get("url"))
        print("Cleaned URL:", url)

        if not url:
            print("IGNORED URL:", url)
            return Response({"status": "ignored"}, status=200)

        try:
            child_obj = models.child.objects.get(id=child_id)
        except models.child.DoesNotExist:
            return Response({"error": "Child not found"}, status=404)

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

    # ── FILTER 1: Too short ──
    if not message or len(message.strip()) < 5:
        return Response({"status": "ignored"}, status=200)

    # ── FILTER 2: UI Noise ──
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

    # Date pattern
    if re.match(r'^\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}$', msg_lower):
        return Response({"status": "ignored_date"}, status=200)

    if re.match(r'^\d{1,2}\s+(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{4}$', msg_lower):
        return Response({"status": "ignored_date"}, status=200)

    # Call duration
    if re.match(r'^\d+\s*(sec|secs|min|mins|second|seconds|minute|minutes)$', msg_lower):
        return Response({"status": "ignored_duration"}, status=200)

    # Phone number
    if re.match(r'^\+?[\d\s\-]{10,15}$', msg_lower):
        return Response({"status": "ignored_phone"}, status=200)

    # System messages
    if "pinned a message" in msg_lower:
        return Response({"status": "ignored_system"}, status=200)

    # ── FILTER 3: Child exist ──
    try:
        child_obj = models.child.objects.get(id=child_id)
    except models.child.DoesNotExist:
        return Response({"error": "Child not found"}, status=404)

    print(f"Chat — Child: {child_id} | App: {app_name} | Msg: {message}")

    # ── Timestamp parse ──
    try:
        msg_time = make_aware(datetime.fromisoformat(timestamp_str))
    except:
        msg_time = timezone.now()

    # ── FILTER 4: Purana message — historical ──
    # WhatsApp app khulne pe poori history load karti hai
    # Sirf last 5 minute ke messages pe agent chalao
    time_diff = timezone.now() - msg_time
    is_historical = time_diff.total_seconds() > 300  # 5 minutes

    # ── FILTER 5: Duplicate ──
    existing = models.ChatMessage.objects.filter(
        child=child_obj,
        app_name=app_name,
        message=message,
        sender=sender,
    ).filter(
        timestamp__gte=timezone.now() - timedelta(minutes=10)
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

    # ── Historical message — agent mat chalao ──
    if is_historical:
        return Response({
            "status":  "historical",
            "chat_id": chat_obj.id,
        }, status=200)

    # ── Agent Call — sirf naye messages pe ──
    try:
        result = chat_agent.invoke({
            "child_id":    int(child_id),
            "app_name":    app_name,
            "message":     message,
            "sender":      sender,
            "chat_obj_id": chat_obj.id,
            "ml_category": "none",

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

        return Response({
            "status":    "processed",
            "chat_id":   chat_obj.id,
            "category":  result.get("final_category"),
            "action":    result.get("action"),
            "risk_level": result.get("risk_level"),
        }, status=200)

    except Exception as e:
        print(f"Chat Agent Error: {traceback.format_exc()}")
        return Response({
            "status":  "saved",
            "chat_id": chat_obj.id,
        }, status=200)
    