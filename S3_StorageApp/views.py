from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.forms import AuthenticationForm
from .forms import UserForm, UploadedFileForm
from django.contrib.auth.decorators import login_required


def index(request):
    return render(request, 'index.html')


@login_required
def upload(request):
    if request.method == 'POST':
        form = UploadedFileForm(request.POST, request.FILES)
        if form.is_valid():
            uploaded_file = form.save(commit=False)
            uploaded_file.user = request.user  # Associate the file with the logged-in user
            uploaded_file.save()
            return redirect('upload_success')  # Ensure you have a URL pattern named 'upload_success'
    else:
        form = UploadedFileForm()
    return render(request, 'upload.html', {'form': form})


def register(request):
    if request.method == 'POST':
        form = UserForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('home')
    else:
        form = UserForm()
    return render(request, 'register.html', {'form': form})


def login(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            username = form.cleaned_data.get('username')
            password = form.cleaned_data.get('password')
            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                return redirect('home')  # Redirect to a home page or another page
    else:
        form = AuthenticationForm()
    return render(request, 'login.html', {'form': form})


def upload_success(request):
    return render(request, 'upload_success.html')
