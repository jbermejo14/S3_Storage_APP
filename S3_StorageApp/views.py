from django.shortcuts import render, redirect
from .forms import UploadedFileForm


def index(request):
    if request.method == 'POST':
        form = UploadedFileForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('upload_success')
    else:
        form = UploadedFileForm()
    return render(request, 'index.html', {'form': form})


def upload_success(request):
    return render(request, 'upload_success.html')
