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
    if 'auth.nurse' not in user.get_all_permissions() or 'auth.patient' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")
    if request.method == "POST":
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        confirmpassword = request.POST.get('confirmpassword', '')
        email = request.POST.get('email', '')
        firstname = request.POST.get('firstname', '')
        lastname = request.POST.get('lastname', '')
        phone = request.POST.get('phone', '')
        hospital = request.POST.get('hospital', '')
        if username == '' or password == '' or confirmpassword == '' or email == '' or \
                firstname == '' or lastname == '' or phone == '' \
                 or hospital == '':
            return render(request, 'patients/nurseRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Missing Required Field", "hospitals" : Hospital.objects.order_by("name")})

        if not validateEmail(email):
            return render(request, 'patients/nurseRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Invalid Email Address", "hospitals" : Hospital.objects.order_by("name") })

        if confirmpassword != password:
            return render(request, 'patients/nurseRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Password Mismatch", "hospitals" : Hospital.objects.order_by("name") })



        try:
            user = User.objects.create_user(username=username, email=email, password=password)
            user.last_name = lastname
            user.first_name = firstname

            permission = Permission.objects.get(name='Is Nurse')
            user.user_permissions.add(permission)
        except IntegrityError:
            return render(request, 'patients/nurseRegister.html', {"messagenum": get_number_of_unread(user),"errortext" : "Username is already taken", "hospitals" : Hospital.objects.order_by("name") })


        newNurse = Nurse(firstName=firstname, \
                             lastName=lastname, \
                             hospital=Hospital.objects.get(name=hospital), \
                             userNameField=username, \
                             phone=phone)



        user.save()


        newNurse.save()
        log_add("Nurse " + firstname + " " + lastname + " has been created.")

        return HttpResponseRedirect("/administration")

    else :


        return render(request, 'patients/nurseRegister.html', {"messagenum": get_number_of_unread(user),"states" : states, "hospitals" : Hospital.objects.order_by("name") })


def validateEmail( email ):
    from django.core.validators import validate_email
    from django.core.exceptions import ValidationError
    try:
        validate_email( email )
        return True
    except ValidationError:
        return False

#Copyright StackOverflowGooglers 2015
