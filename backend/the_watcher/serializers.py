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
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(max_length=250)

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
