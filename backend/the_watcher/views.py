from django.shortcuts import render
from . serializers import ParentSerializer,OtpSerializer,PasswordResetSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth import authenticate
import random
from . import models
from django.core.mail import send_mail
from django.contrib.auth.models import User



# Sign UP API
@api_view(['POST'])
def signup_api(request):
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        send_otp(serializer.validated_data['email'], serializer.validated_data['username'], serializer.validated_data['password'])
        
        # user = User.objects.create_user(
        #     username=serializer.validated_data['username'],
        #     email=serializer.validated_data['email'],
        #     password=serializer.validated_data['password']
        # )
        


        # refresh = RefreshToken.for_user(user)
        return Response({
            "message": "OTP sent to your email."
        }, status=status.HTTP_200_OK)
    return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

# Log In API 
@api_view(['POST'])
def login_api(request):
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        user = authenticate(request, email=email, password=password)
        if user is not None:
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

def send_otp(email,username,password):
    # serializer = ParentSerializer(data=request.data)
    # email = serializer.validated_data['email']
    try:
        # user = User.objects.get(email=email)
        otp = generate_otp()
        print (otp)
        models.otp.objects.create(email=email,code=otp,username=username,password=password)
        print("Created")
        #send_mail(
            #subject='OTP for TheWatcher App',
            #message=f'Your OTP code is {otp}',
            #from_email='22ntucs1145amnaali@gmail.com',
            #recipient_list=[email],
            #fail_silently=False
           
        #)
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
       #email = serializer.validated_data['email']
        code = serializer.validated_data['otp']
        
        otp_record = models.otp.objects.filter( code=code,is_verified=False).last()
        if not otp_record:
            return Response({"result": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)
        if otp_record.is_expired():
            return Response({"result": "OTP has expired"}, status=status.HTTP_400_BAD_REQUEST)
        otp_record.is_verified = True
        otp_record.save()

        user = User.objects.create_user(
            username=otp_record.username,
            email=otp_record.email,
            password=otp_record.password
        )
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
        
