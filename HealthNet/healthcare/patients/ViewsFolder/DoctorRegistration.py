#Copyright StackOverflowGooglers 2015
from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth.models import User
from django.contrib.auth.models import Permission
from django.contrib import auth
from django.contrib.contenttypes.models import ContentType
from django.db import IntegrityError

from ..models import *

# Create your views here.


def index(request):
    user = request.user
    #Redirect if not admin
    if 'auth.nurse' not in user.get_all_permissions() or 'auth.patient' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")
    #Get details
    if request.method == "POST":
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        confirmpassword = request.POST.get('confirmpassword', '')
        email = request.POST.get('email', '')
        firstname = request.POST.get('firstname', '')
        lastname = request.POST.get('lastname', '')
        phone = request.POST.get('phone', '')

        #Validate info
        if username == '' or password == '' or confirmpassword == '' or \
                firstname == '' or lastname == '' or phone == '' or email == '':
            return render(request, 'patients/doctorRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Missing Required Field"})

        if not validateEmail(email):
            return render(request, 'patients/doctorRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Invalid Email Address" })

        if confirmpassword != password:
            return render(request, 'patients/doctorRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Password Mismatch" })


        #Create user and doctor
        try:
            user = User.objects.create_user(username=username, email=email, password=password)
            user.last_name = lastname
            user.first_name = firstname

            permission = Permission.objects.get(name='Is Doctor')
            user.user_permissions.add(permission)
        except IntegrityError:
            return render(request, 'patients/doctorRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Username is already taken"})


        newDoctor = Doctor(firstName=firstname, \
                             lastName=lastname, \
                             userNameField=username, \
                             phone=phone)



        user.save()

        newDoctor.save()
        log_add("Doctor " + firstname + " " + lastname + " has been created.")

        return HttpResponseRedirect("/administration")

    else :


        return render(request, 'patients/doctorRegister.html', {"messagenum": get_number_of_unread(user), 'name': user.first_name + " " + user.last_name})

"""
Validate a string as an email.
"""
def validateEmail( email ):
    from django.core.validators import validate_email
    from django.core.exceptions import ValidationError
    try:
        validate_email( email )
        return True
    except ValidationError:
        return False

#Copyright StackOverflowGooglers 2015
