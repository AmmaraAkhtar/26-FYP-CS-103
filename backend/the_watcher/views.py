from django.shortcuts import render
from rest_framework import ParentSerializer
from django.restFramework import response
from django.rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.decorators import api_view, permission_classes
from django.contrib.auth import authenticate
import random
from . import models
from django.core.mail import send_mail



# Sign UP API
@api_view(['POST'])
def signup_api(request):
    serializer = ParentSerializer(data=request.data)
    if serializer.is_valid():
        user = User.objects.create_user(
            username=serializer.validated_data['username'],
            email=serializer.validated_data['email'],
            password=serializer.validated_data['password']
        )
        refresh = RefreshToken.for_user(user)
        return response.Response({
            "user": {
                "username": user.username,
                "email": user.email
            },
            "tokens": {
                "refresh": str(refresh),
                "access": str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)
    return response.Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# Log In API 
@api_view(['POST'])
def login_api(request):
    serializer = ParaentSerializer(data=request.data)
    email = serializer.validated_data['email']
    password = serializer.validated_data['password']
    user = authenticate(request, email=email, password=password)
    if user is not None:
        refresh = RefreshToken.for_user(user)
        return response.Response({
            "user": {
                "username": user.username,
                "email": user.email
            },
            "tokens": {
                "refresh": str(refresh),
                "access": str(refresh.access_token),
            }
        }, status=status.HTTP_200_OK)
    return response.Response({"Error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

# Email Check API
@api_view(['POST'])
def checkEmail_api(request):
    serializer = ParentSerializer(data=request.data)
    email = serializer.validated_data['email']
    try:
        user = User.objects.get(email=email)
        
       
        return response.Response({"result": True}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return response.Response({"result": False}, status=status.HTTP_200_OK)

# Reset Password API
@api_view(['POST'])
def resetPassword_api(request):
    serializer = ParentSerializer(data=request.data)
    email = serializer.validated_data['email']
    new_password = serializer.validated_data['new_password']
    try:
        user = User.objects.get(email=email)
        user.set_password(new_password)
        user.save()
        return response.Response({"result": "Password reset successful"}, status=status.HTTP_200_OK)
    except:
        return response.Response({"result": "Error Occured"}, status=status.HTTP_404_NOT_FOUND)
    

# Function for OTP Generation
def generate_otp():
    return str(random.randint(1000, 9999))

# OTP Generation API
@api_view(['POST'])
def otpGeneration_api(request):
    serializer = ParentSerializer(data=request.data)
    email = serializer.validated_data['email']
    try:
        user = User.objects.get(email=email)
        otp = generate_otp()
        models.otp.objects.create(email=email,code=otp)
        send_mail(
            subject='OTP for TheWatcher App',
            message=f'Your OTP code is {otp}',
            from_email='anasahmed.ru6@gmail.com',
            recipient_list=[email],
           
        )
        return response.Response({"result": "otp sent successfully"}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return response.Response({"result": "User does not exist"}, status=status.HTTP_404_NOT_FOUND)

# OTP Verification API
@api_view(['POST'])
def otpVerification_api(request):
    serializer = OtpSerializer(data=request.data)
    email = serializer.validated_data['email']
    code = serializer.validated_data['otp']
    try:
        otp_record = models.otp.objects.filter(email=email, code=code,is_verified=False).last()
        otp_record.is_verified = True
        otp_record.save()
        return response.Response({"result": "OTP verified successfully"}, status=status.HTTP_200_OK)
    except:
        return response.Response({"result": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)
