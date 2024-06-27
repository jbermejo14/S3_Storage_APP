from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from .forms import UploadedFileForm
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.decorators import login_required

from .models import UploadedFile


@login_required(login_url='login_view')
def index(request):
    return render(request, 'index.html')


@login_required(login_url='login_view')
def upload(request):
    if request.method == 'POST':
        form = UploadedFileForm(request.POST, request.FILES)
        if form.is_valid():
            uploaded_file = form.save(commit=False)
            uploaded_file.user_id = request.user.id  # Set user_id to current user's ID
            uploaded_file.save()
            return redirect('upload_success')
    else:
        form = UploadedFileForm()
    return render(request, 'upload.html', {'form': form})


def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password1')
            user = authenticate(request, username=username, password=password)

            if user is not None:
                login(request, user)
                return redirect('index')
            else:
                form.add_error(None, 'Authentication failed. Please try again.')
    else:
        form = UserCreationForm()

    return render(request, 'register.html', {'form': form})


def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(request=request, username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect('index')  # Redirect to wherever you want the user to go after logging in
    else:
        form = AuthenticationForm()
    return render(request, 'login.html', {'form': form})


@login_required(login_url='login_view')
def upload_success(request):
    return render(request, 'upload_success.html')


def logout_view(request):
    logout(request)
    return redirect('login_view')


def view_upload(request):
    uploaded_files = UploadedFile.objects.filter(user=request.user)
    return render(request, 'view_uploads.html', {'uploaded_files': uploaded_files})

