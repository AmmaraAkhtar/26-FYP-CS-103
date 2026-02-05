from django.db import models
from django.utils import timezone
from datetime import timedelta

# Create your models here.
class otp(models.Model):
    email = models.EmailField(unique=True)
    code = models.CharField(max_length=4)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)
    
    def is_expired(self):
        if timezone.now() > self.created_at + timedelta(minutes=10):
            return True

