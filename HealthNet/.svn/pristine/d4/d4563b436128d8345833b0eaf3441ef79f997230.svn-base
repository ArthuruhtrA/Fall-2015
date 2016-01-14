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
    if not request.user.is_anonymous():
        return HttpResponseRedirect("/calendar")
    if request.method == "POST":
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        confirmpassword = request.POST.get('confirmpassword', '')
        email = request.POST.get('email', '')
        firstname = request.POST.get('firstname', '')
        lastname = request.POST.get('lastname', '')
        city = request.POST.get('city', '')
        state = request.POST.get('state', '')
        address1 = request.POST.get('address1', '')
        phone = request.POST.get('phone', '')
        insurancename = request.POST.get('insurancename', '')
        insuranceid = request.POST.get('insuranceid', '')
        hospital = request.POST.get('hospital', '')
        emergencycontactphone = request.POST.get('emergencycontactphone', '')
        emergencycontactfirstname = request.POST.get('emergencycontactfirstname', '')
        emergencycontactlastname = request.POST.get('emergencycontactlastname', '')
        emergencycontactemail = request.POST.get('emergencycontactemail', '')
        medicalinformation = request.POST.get('medicalinformation', '')
        if username == '' or password == '' or confirmpassword == '' or email == '' or \
                firstname == '' or lastname == '' or city == '' or state == '' or address1 == '' or phone == '' \
                 or insurancename == '' or insuranceid == '' or hospital == '' or \
                        emergencycontactphone == ''or \
                        emergencycontactfirstname == ''or \
                        emergencycontactlastname == ''or \
                        emergencycontactemail == '':
            return render(request, 'patients/patientRegister.html', {"errortext" : "Missing Required Field", 'states' : states, "hospitals" : Hospital.objects.order_by("name")})

        if not validateEmail(email):
            return render(request, 'patients/patientRegister.html', {"errortext" : "Invalid Email Address", 'states' : states, "hospitals" : Hospital.objects.order_by("name") })

        if confirmpassword != password:
            return render(request, 'patients/patientRegister.html', {"errortext" : "Password Mismatch", 'states' : states, "hospitals" : Hospital.objects.order_by("name") })



        try:
            user = User.objects.create_user(username=username, email=email, password=password)
            user.last_name = lastname
            user.first_name = firstname

            permission = Permission.objects.get(name='Is Patient')
            user.user_permissions.add(permission)
        except IntegrityError:
            return render(request, 'patients/patientRegister.html', {"errortext" : "Username is already taken", 'states' : states, "hospitals" : Hospital.objects.order_by("name") })


        newPatient = Patient(firstName=firstname, \
                             lastName=lastname, \
                             hospital=Hospital.objects.get(name=hospital), \
                             userNameField=username, \
                             email=email, \
                             city=city, \
                             state=state, \
                             address1=address1, \
                             phone=phone, \
                             insuranceID=insuranceid, \
                             insuranceName=insurancename, \
                             emergencyContactEmail=emergencycontactemail, \
                             emergencyContactFirstName=emergencycontactfirstname, \
                             emergencyContactLastName=emergencycontactlastname, \
                             emergencyContactPhone=emergencycontactphone, \
                             medicalInformation=medicalinformation)



        user.save()

        newPatient.save()
        log_add("Patient " + firstname + " " + lastname + " has been created.")

        return HttpResponseRedirect("/login")

    else :


        return render(request, 'patients/patientRegister.html', { "states" : states, "hospitals" : Hospital.objects.order_by("name") })


def validateEmail( email ):
    from django.core.validators import validate_email
    from django.core.exceptions import ValidationError
    try:
        validate_email( email )
        return True
    except ValidationError:
        return False

#Copyright StackOverflowGooglers 2015
