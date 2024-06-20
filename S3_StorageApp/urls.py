from django.urls import path
from . import views


urlpatterns = [
    path('', views.index, name='index'),
    path('upload_success', views.upload_success, name='upload_success')
]