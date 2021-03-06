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
    #Redirect if logged in
    if not request.user.is_anonymous():
        return HttpResponseRedirect("/calendar")
    #If it is a POST, then create patient
    context = { "states" : states, "hospitals" : Hospital.objects.order_by("name") }
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

        
        
        #Validate all fields
        if username == '' or password == '' or confirmpassword == '' or email == '' or \
                firstname == '' or lastname == '' or city == '' or state == '' or address1 == '' or phone == '' \
                 or insurancename == '' or insuranceid == '' or hospital == '' or \
                        emergencycontactphone == ''or \
                        emergencycontactfirstname == ''or \
                        emergencycontactlastname == ''or \
                        emergencycontactemail == '':
            context["errortext"] = "Missing Required Field"
            return render(request, 'patients/patientRegister.html', context)

        if not validateEmail(email):
            context["errortext"] = "Invalid Email Address"
            return render(request, 'patients/patientRegister.html', context)

        if confirmpassword != password:
            context["errortext"] = "Password Mismatch"
            return render(request, 'patients/patientRegister.html', context)
		
	#Strip phone numbers of non numeric values
        phone = getPhone(phone)
        emergencycontactphone = getPhone(emergencycontactphone)
		
	#Check length of phone numbers
        if not validatePhone(phone):
            context["errortext"] = "Invalid Phone Number: must have 10 digits, area code and number"
            return render(request, 'patients/patientRegister.html', context)
        
        if not validatePhone(emergencycontactphone):
            context["errortext"] = "Invalid Emergency Contact Phone Number: must have 10 digits, area code and number"
            return render(request, 'patients/patientRegister.html', context)

        try:
            user = User.objects.create_user(username=username, email=email, password=password)
            user.last_name = lastname
            user.first_name = firstname
    
            permission = Permission.objects.get(name='Is Patient')
            user.user_permissions.add(permission)
        except IntegrityError:
            context["errortext"] = "Username is already taken"
            return render(request, 'patients/patientRegister.html', context)


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
                             emergencyContactPhone=emergencycontactphone)



        user.save()

        newPatient.save()
        log_add("Patient " + firstname + " " + lastname + " has been created.")

        return HttpResponseRedirect("/login")

    else :


        return render(request, 'patients/patientRegister.html', context)


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
"""
Remove all non-numeric characters from the phone number
"""
def getPhone( phone ):
    newPhone = ""
    for c in phone:
        if c in "1234567890":
            newPhone += c

    return newPhone

"""
Validate phone number is of correct length 
(10 with area code,  11 with US country code)
"""
def validatePhone( phone ):
    if len(phone) == 10 or len(phone) == 11:
        return True
    else:
        return False
#Copyright StackOverflowGooglers 2015
