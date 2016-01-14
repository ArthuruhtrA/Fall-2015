from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib import auth
from ..models import *
from datetime import datetime

# Edit Details for Patient
def index(request):
    user = request.user

    if not 'auth.patient' in user.get_all_permissions()  or 'auth.nurse' in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    #Get the patient from the database
    patient = Patient.objects.get(userNameField=user.username)
    context = {'messagenum': get_number_of_unread(user),
               'patient': patient,
               'states': states,
               'hospitals' : Hospital.objects.order_by("name")}

    if request.method == "POST":
        #Add message to context in case there are errors with the form
        

        #Get all values from the POST
        firstName = request.POST.get('firstname', '')
        lastName = request.POST.get('lastname', '')
        email = request.POST.get('email', '')
        city = request.POST.get('city', '')
        state = request.POST.get('state', '')
        address1 = request.POST.get('address1', '')
        phone = request.POST.get('phone', '')
        insuranceName = request.POST.get('insurancename', '')
        insuranceID = request.POST.get('insuranceid', '')
        hospital = request.POST.get('hospital', '')
        emergencyContactFirstName = request.POST.get('emergencycontactfirstname', '')
        emergencyContactLastName = request.POST.get('emergencycontactlastname', '')
        emergencyContactPhone = request.POST.get('emergencycontactphone', '')
        emergencyContactEmail = request.POST.get('emergencycontactemail', '')
        password = request.POST.get('password', '')

        #Validate fields
        if firstName == '' or lastName == '' or email == '' or not validateEmail(email) or city == '' or state == '' or address1 == '' or phone == '' or \
            insuranceName == '' or insuranceID == '' or hospital == '' or emergencyContactFirstName == '' \
                or emergencyContactLastName == '' or emergencyContactPhone == '' \
                or emergencyContactEmail == ''\
                or not validateEmail(emergencyContactEmail ):
            context['errortext'] = "Missing Required Field"
            return render(request, 'patients/patientEditPatientDetails.html', context)
			
	#Strip phone number of all non-numeric values
        phone = getPhone(phone)
        emergencyContactPhone = getPhone(emergencyContactPhone)
		
	#Check length of both phone numbers
        if not validatePhone(phone):
            context['errortext'] = "Invalid Phone Number: must have 10 digits, area code and number"
            return render(request, 'patients/patientEditPatientDetails.html', context)

        if not validatePhone(emergencyContactPhone):
            context["errortext"] = "Invalid Emergency Contact Phone Number: must have 10 digits, area code and number"
            return render(request, 'patients/patientEditPatientDetails.html', context)
        
        #Set new values of patient and user
        patient.firstName = firstName
        patient.lastName = lastName
        patient.email = email
        patient.city = city
        patient.state = state
        patient.address1 = address1
        patient.phone = phone
        patient.insuranceName = insuranceName
        patient.insuranceID = insuranceID
        patient.hospital = Hospital.objects.get(name=hospital)
        patient.emergencyContactFirstName = emergencyContactFirstName
        patient.emergencyContactLastName = emergencyContactLastName
        patient.emergencyContactPhone = emergencyContactPhone
        patient.emergencyContactEmail = emergencyContactEmail

        user.firstName = firstName
        user.lastName = lastName
        user.set_password(password)

        patient.save()
        user.save()

        user = auth.authenticate(username=user.username, password=password)
        auth.login(request, user)

        #Add notice to log
        log_add("Patient " + str(patient) + " edited details.")

        return HttpResponseRedirect("/patientviewpatientdetails")

    else :
        #Using previous context, load the page
        return render(request, 'patients/patientEditPatientDetails.html', context)

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
