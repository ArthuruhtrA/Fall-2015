#Copyright 2015 StackOverflowGooglers

from django.shortcuts import render
from django.contrib.auth.models import Permission, User
from django.shortcuts import get_object_or_404

from ..models import *


from django.http import HttpResponse, HttpResponseRedirect

# Create your views here.

def index(request):
    user = request.user
    #Redirect if not admin
    if 'auth.doctor' not in user.get_all_permissions() or 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    context = {'messagenum': get_number_of_unread(request.user), 'name': user.first_name + " " + user.last_name}
    return render(request, 'patients/adminHome.html', context)


#Copyright 2015 StackOverflowGooglers
