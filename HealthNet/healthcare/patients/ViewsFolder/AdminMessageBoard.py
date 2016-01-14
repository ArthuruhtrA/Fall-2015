from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime
import patients.ViewsFolder.DoctorAdmitDischargePatient

# Create your views here.

def index(request):

    user = request.user
    #Redirect if not logged in
    if 'auth.doctor' not in user.get_all_permissions() or 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    #Get message from POST
    if request.method == "POST":
        message = request.POST.get('message', '')



        newMessage = AdminNewsFeed(message=message, dateTime=datetime.datetime.now())
        newMessage.save()






    messageList = AdminNewsFeed.objects.order_by("-dateTime")

    messageListTuple = []


    for message in messageList:
        messageListTuple += [(message.dateTime, message.message)]


    context = {'messages': messageListTuple,
               "messagenum": get_number_of_unread(user), 'name': user.first_name + " " + user.last_name}
    return render(request, 'patients/adminMessageBoard.html', context)
