#Copyright StackOverflowGooglers 2015
from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth.models import User
from django.contrib.auth.models import Permission
from django.contrib import auth
from django.contrib.contenttypes.models import ContentType
from django.db import IntegrityError
import datetime

from ..models import *

# Create your views here.


def index(request, person):
    user = request.user
    if user.is_anonymous():
        return HttpResponseRedirect("/notauthorized")

    permissions = user.get_all_permissions()
    if 'auth.patient' in permissions and 'auth.doctor' in permissions:
        isSuperuser = True
        pOd = 'admin'
        userobj = user
    else:
        pOd = 'patient' if 'auth.patient' in permissions else 'doctor' if 'auth.doctor' in permissions else 'nurse'
        userobj = Patient.objects.get(userNameField=user.username) if pOd == "patient" else Doctor.objects.get(userNameField=user.username) if pOd == "doctor" else Nurse.objects.get(userNameField=user.username)

        isSuperuser = False

    try:
        whoelse = Patient.objects.get(userNameField=person)
    except:
        try:
            whoelse = Doctor.objects.get(userNameField=person)
        except:
            try:
                whoelse = Nurse.objects.get(userNameField=person)
            except:
                try:
                    whoelse = User.objects.get_by_natural_key(person)
                    whoelse = whoelse.first_name + " " + whoelse.last_name
                    isSuperuser = True
                except:
                    print("Error: Could not find user " + person + ".")
                    whoelse = userobj
    if not isSuperuser:
        whoelse = whoelse.firstName + " " + whoelse.lastName

    if request.method == "POST":
        message = request.POST.get('message', '')
        if message == '':
            return render(request, 'patients/messageSend.html', {'name': user.first_name + " " + user.last_name, "pOd": pOd, "who": user.username, "whoelse": whoelse, "messagenum": get_number_of_unread(user), "messages" : getAllMessagesBetweenPeople(user, person)})

        newMessage = PrivateMessage(sender=user, receiver=person, dateTime=datetime.datetime.now(), message=message)

        newMessage.save()

        return render(request, 'patients/messageSend.html', {'name': user.first_name + " " + user.last_name, "pOd": pOd, "who": user.username, "whoelse": whoelse, "messages" : getAllMessagesBetweenPeople(user, person), "messagenum": get_number_of_unread(user)})
    else :

        return render(request, 'patients/messageSend.html', {'name': user.first_name + " " + user.last_name, "pOd": pOd, "who": user.username, "whoelse": whoelse, "messages" : getAllMessagesBetweenPeople(user, person), "messagenum": get_number_of_unread(user)})

def getAllMessagesBetweenPeople(one, two):
    allMessages = PrivateMessage.objects.order_by("dateTime")

    selectMessages = []

    for message in allMessages:
        if message.sender == two and message.receiver == one:
            message.isUnread = False
            message.save()
        if (message.sender == one and message.receiver == two) or (message.sender == two and message.receiver == one):

            selectMessages += [message]



    selectMessages.reverse()

    return selectMessages

#Copyright StackOverflowGooglers 2015
