from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.signup_api),
    path('login/', views.login_api),
    path('checkEmail/', views.checkEmail_api),
    path('resetPassword/', views.resetPassword_api),
    #path('generateOtp/', views.otpGeneration_api),
    path('verifyOtp/', views.otpVerification_api),
    path('resendOtp/', views.resendOtp_api),
    path('createChild/', views.createChild_api),
    path('pairDevice/', views.pairingCodeVerification_api),
]