#Copyright 2015 StackOverflowGooglers

from django.shortcuts import render
from django.contrib.auth.models import Permission, User
from django.shortcuts import get_object_or_404

from ..models import *


from django.http import HttpResponse, HttpResponseRedirect

# Create your views here.

def index(request):
    if request.user.is_authenticated():
        return HttpResponseRedirect("/calendar")#Redirect to calendar if logged in



    messageList = AdminNewsFeed.objects.order_by("-dateTime")

    messageListTuple = []


    for message in messageList:
        messageListTuple += [(message.dateTime, message.message)]

    context = {'messages': messageListTuple}
    return render(request, 'patients/index.html', context)


#Copyright 2015 StackOverflowGooglers
