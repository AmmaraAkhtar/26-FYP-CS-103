from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password

# Parent Serializer
class ParentSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email','password']
        
    def validate(self,data):
            if ' ' in data['username']:
                raise serializers.ValidationError("Username cannot contain spaces.")
            if User.objects.filter(email=data['email']).exists():
                raise serializers.ValidationError("Email is already in use.")
            
            elif validate_password(data['password']) is not None:
               raise serializers.ValidationError(validate_password(data['password']))
            

            return data

        
# otp Serializer
class OtpSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=4)
    

    def validate_otp(self, data):
        if len(data) != 4 :
            raise serializers.ValidationError("OTP must be a 4-digit number.")
        elif not data.isdigit():
            raise serializers.ValidationError("OTP must contain only digits.")
       # elif data.is_expired():
            #raise serializers.ValidationError("OTP has expired.")
        return data

#PasswordReset Serializer
class PasswordResetSerializer(serializers.Serializer):
    email = serializers.EmailField()
    new_password = serializers.CharField(max_length=250)

    def validate_new_password(self, data):
        if validate_password(data) is not None:
            raise serializers.ValidationError(validate_password(data))
        return data
    
# Log in Serializer
class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(max_length=250)

# Child Serializer
class ChildSerializer(serializers.Serializer):
    firstname = serializers.CharField(max_length=100)
    lastname = serializers.CharField(max_length=100)
    age = serializers.IntegerField()
    screen_time_limit = serializers.IntegerField(default=60)  # in minutes

    def validate_age(self, data):
        if data < 0 or data > 18:
            raise serializers.ValidationError("Age must be between 0 and 18.")
        return data

# Pairing Code Serializer
class PairingCodeSerializer(serializers.Serializer):
    pairing_code = serializers.CharField(max_length=4)

    def validate_pairing_code(self, data):
        if len(data) != 4:
            raise serializers.ValidationError("Pairing code must be a 4-digit number.")
        elif not data.isdigit():
            raise serializers.ValidationError("Pairing code must contain only digits.")
        return data
    
    
