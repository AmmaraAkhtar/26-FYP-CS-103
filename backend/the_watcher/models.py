from django.db import models
from django.utils import timezone
from datetime import timedelta
from django.contrib.auth.models import User

# Create your models here.
class otp(models.Model):
    email = models.EmailField(unique=False)
    code = models.CharField(max_length=4)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)
    
    def is_expired(self):
        if timezone.now() > self.created_at + timedelta(minutes=10):
            return True

# Child Model 

class child(models.Model):
    
    firstname = models.CharField(max_length=100)
    lastname = models.CharField(max_length=100,default = ' ')
    age = models.IntegerField()
    parent = models.ForeignKey(User, on_delete=models.CASCADE)
    pairingCode = models.CharField(max_length=4,unique=True,null=True)
    screen_time_limit = models.IntegerField(default=60)  # in minutes
    is_paired = models.BooleanField(default=False)


# Pairing Code Model
class pairingCode(models.Model):
    pairing_code = models.CharField(max_length=4,unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    parent = models.ForeignKey(User, on_delete=models.CASCADE)
    child = models.ForeignKey(child, on_delete=models.CASCADE, null=True)
    is_used = models.BooleanField(default=False)

    def is_expired(self):
        if timezone.now() > self.created_at + timedelta(minutes=10):
            return True





