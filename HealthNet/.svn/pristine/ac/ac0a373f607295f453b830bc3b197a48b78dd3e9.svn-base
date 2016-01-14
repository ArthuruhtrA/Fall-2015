from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from django.contrib import auth
from ..models import log_add

# Create your views here.

def index(request):


    user = request.user

    if user.username:
        log_add(user.first_name + " " + user.last_name + " logged out.")
        auth.logout(request)
    else:
        log_add("Nonexistent user attempted to log out.")
    return HttpResponseRedirect("../")
