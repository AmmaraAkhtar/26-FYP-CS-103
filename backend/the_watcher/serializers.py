from django.rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password

# Parent Serializer
class ParentSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email','password','password2']
        
        def validate(self,data):
            if ' ' in data['username']:
                raise serializers.ValidationError("Username cannot contain spaces.")
            if User.objects.filter(email=data['email']).exists():
                raise serializers.ValidationError("Email is already in use.")
            elif data['password'] != data['password2']:
                raise serializers.ValidationError("Passwords do not match.")
            elif validate_password(data['password']) is not None:
                raise serializers.ValidationError(validate_password(data['password']))
            return data

        
# otp Serializer
class OtpSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=4)

    def validate_email(self, data):
        if len(data['otp']) != 4 :
            raise serializers.ValidationError("OTP must be a 4-digit number.")
        elif not data['otp'].isdigit():
            raise serializers.ValidationError("OTP must contain only digits.")
        elif data['otp'].is_expired():
            raise serializers.ValidationError("OTP has expired.")
        return data

