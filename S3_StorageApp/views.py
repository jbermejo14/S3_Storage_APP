from django.shortcuts import render, redirect
from .forms import UploadedFileForm


def upload_file(request):
    if request.method == 'POST':
        form = UploadedFileForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('upload_success')
    else:
        form = UploadedFileForm()
    return render(request, 'upload.html', {'form': form})


def upload_success(request):
    return render(request, 'upload_success.html')
