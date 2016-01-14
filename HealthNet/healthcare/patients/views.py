#Copyright StackOverflowGooglers 2015

from django.shortcuts import render
from datetime import date

from django.contrib.auth.models import User


import patients.ViewsFolder.PatientCreateAppointment
import patients.ViewsFolder.DoctorCreateAppointment
import patients.ViewsFolder.PatientUpdateCancelAppointment
import patients.ViewsFolder.DoctorUpdateCancelAppointment
import patients.ViewsFolder.HomePage
import patients.ViewsFolder.NurseUpdateAppointment
import patients.ViewsFolder.NurseHome
import patients.ViewsFolder.NurseWeek
import patients.ViewsFolder.NurseDay
import patients.ViewsFolder.PatientDoctorViewCalendar
import patients.ViewsFolder.PatientViewDetails
import patients.ViewsFolder.PatientEditDetails
import patients.ViewsFolder.PatientRegistration
import patients.ViewsFolder.PatientDoctorNurseLogout
import patients.ViewsFolder.PatientDoctorNurseLogin
import patients.ViewsFolder.DoctorNurseLogin
import patients.ViewsFolder.NotAuthorized
import patients.ViewsFolder.NurseUpdateAppointment
import patients.ViewsFolder.AdminHome
import patients.ViewsFolder.AdminViewLogs
import patients.ViewsFolder.DoctorRegistration
import patients.ViewsFolder.NurseRegistration
import patients.ViewsFolder.MessageHome
import patients.ViewsFolder.MessageSend
import patients.ViewsFolder.ListOfPatients
import patients.ViewsFolder.DoctorViewPatientDetails
import patients.ViewsFolder.DoctorAdmitDischargePatient
import patients.ViewsFolder.DoctorPrescribe
import patients.ViewsFolder.DoctorReleaseTest
import patients.ViewsFolder.DoctorAddFile
import patients.ViewsFolder.AdminMessageBoard
import patients.ViewsFolder.DoctorEditTransferPatient
import patients.ViewsFolder.PatientExportInfo

from django.http import HttpResponse, HttpResponseRedirect

# Create your views here.


def index(request):
    return patients.ViewsFolder.HomePage.index(request)

def AdminHome(request):
    return patients.ViewsFolder.AdminHome.index(request)

def ViewLogs(request):
    return patients.ViewsFolder.AdminViewLogs.index(request)

def AdminMessageBoard(request):
    return patients.ViewsFolder.AdminMessageBoard.index(request)

def CreateDoctor(request):
    return patients.ViewsFolder.DoctorRegistration.index(request)

def CreateNurse(request):
    return patients.ViewsFolder.NurseRegistration.index(request)

def MessageHome(request):
    return patients.ViewsFolder.MessageHome.index(request)

def ListOfPatients(request):
    return patients.ViewsFolder.ListOfPatients.index(request)

def DoctorViewPatientDetails(request, text):
    return patients.ViewsFolder.DoctorViewPatientDetails.index(request, text)

def DoctorEditTransferPatient(request, text):
    return patients.ViewsFolder.DoctorEditTransferPatient.index(request, text)

def DoctorPrescribe(request, text):
    return patients.ViewsFolder.DoctorPrescribe.index(request, text)

def DoctorReleaseTest(request, text):
    return patients.ViewsFolder.DoctorReleaseTest.index(request, text)

def DoctorAddFile(request, text):
    return patients.ViewsFolder.DoctorAddFile.index(request, text)

def DoctorAdmitDischargePatient(request, text):
    return patients.ViewsFolder.DoctorAdmitDischargePatient.index(request, text)

def PatientDoctorCalendar(request, cal_year=date.today().year, cal_month=date.today().month, cal_day=date.today().day):
    return patients.ViewsFolder.PatientDoctorViewCalendar.index(request, cal_year, cal_month, cal_day)


def PatientDoctorNurseLogout(request):
    return patients.ViewsFolder.PatientDoctorNurseLogout.index(request)

def PatientDoctorNurseLogin(request):
    return patients.ViewsFolder.PatientDoctorNurseLogin.index(request)

def DoctorNurseLogin(request):
    return patients.ViewsFolder.DoctorNurseLogin.index(request)

def PatientRegister(request):
    return patients.ViewsFolder.PatientRegistration.index(request)

def PatientExportInfo(request):
    return patients.ViewsFolder.PatientExportInfo.index(request)

def PatientViewPatientDetails(request):
    return patients.ViewsFolder.PatientViewDetails.index(request)

def PatientEditPatientDetails(request):
    return patients.ViewsFolder.PatientEditDetails.index(request)

def NotAuthorized(request):
    return patients.ViewsFolder.NotAuthorized.index(request)

def PatientCreateAppointment(request):
    return patients.ViewsFolder.PatientCreateAppointment.index(request)

def DoctorCreateAppointment(request):
    return patients.ViewsFolder.DoctorCreateAppointment.index(request)

def MessageSend(request, text):
    person=User.objects.get(username=text)
    return patients.ViewsFolder.MessageSend.index(request, person)

def DoctorUpdateCancelAppointment(request, text):
    return patients.ViewsFolder.DoctorUpdateCancelAppointment.index(request, text)

def PatientUpdateCancelAppointment(request, text):
    return patients.ViewsFolder.PatientUpdateCancelAppointment.index(request, text)

def NurseUpdateAppointment(request, text):
    return patients.ViewsFolder.NurseUpdateAppointment.index(request, text)

def DoctorDeleteAppointment(request, text):
    return patients.ViewsFolder.DoctorUpdateCancelAppointment.cancelAppointment(request, text)

def PatientDeleteAppointment(request, text):
    return patients.ViewsFolder.PatientUpdateCancelAppointment.cancelAppointment(request, text)

def NurseHome(request):
    return patients.ViewsFolder.NurseHome.index(request)

def NurseWeek(request, patientdoctorid):
    return patients.ViewsFolder.NurseWeek.index(request, patientdoctorid)

def NurseDay(request, patientdoctorid, daynumber):
    return patients.ViewsFolder.NurseDay.index(request, patientdoctorid, int(daynumber))




#Copyright StackOverflowGooglers 2015
