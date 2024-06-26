from django.shortcuts import render, redirect
from .forms import UploadedFileForm, UserForm


def index(request):
    if request.method == 'POST':
        form = UploadedFileForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('upload_success')
    else:
        form = UploadedFileForm()
    return render(request, 'index.html', {'form': form})


def register(request):
    form = UserForm()
    if request.method == 'POST':
        form = UserForm(request.POST)

    context = {'form': form}
    return render(request, 'register.html', context)


def login(request):
    return render(request, 'login.html')


def upload_success(request):
    return render(request, 'upload_success.html')
