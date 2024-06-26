from django import forms
from django.contrib.auth.forms import UserCreationForm

from .models import UploadedFile


class UploadedFileForm(forms.ModelForm):
    class Meta:
        model = UploadedFile
        fields = ['title', 'file']

