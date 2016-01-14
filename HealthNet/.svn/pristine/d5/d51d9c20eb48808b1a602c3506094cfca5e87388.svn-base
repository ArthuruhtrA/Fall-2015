#Copyright 2015 StackOverflowGooglers

from django.shortcuts import render
from django.contrib.auth.models import Permission, User
from django.shortcuts import get_object_or_404

from ..models import *


from django.http import HttpResponse, HttpResponseRedirect

# Create your views here.

def index(request):
    #user = get_object_or_404(User, pk=user_id)
    testString = "Hello world from HomePage.py"
    context = {"messagenum": get_number_of_unread(request.user),'testString': testString}
    return render(request, 'patients/adminHome.html', context)


#Copyright 2015 StackOverflowGooglers