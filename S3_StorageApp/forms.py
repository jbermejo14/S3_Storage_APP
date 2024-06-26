from django import forms
from django.contrib.auth.forms import UserCreationForm

from .models import UploadedFile, User


class UploadedFileForm(forms.ModelForm):
    class Meta:
        model = UploadedFile
        fields = ['title', 'file']


class UserForm(UserCreationForm):
    email = forms.EmailField(required=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password']