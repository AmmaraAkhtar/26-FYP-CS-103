from django.shortcuts import render
from . serializers import ParentSerializer,OtpSerializer,PasswordResetSerializer,LoginSerializer,ChildSerializer,PairingCodeSerializer,PairedChildSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth import authenticate
import random
from . import models
from django.core.mail import send_mail
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import timedelta



# Sign UP API
@api_view(['POST'])
def signup_api(request):
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
        if child:
            child.is_paired = True
            child.save()

        return Response({"message": "Pairing successful"}, status=status.HTTP_200_OK)
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