import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'healthcare.settings')

import django
django.setup()

from patients.models import Hospital, Patient,Doctor,Nurse
from django.contrib.auth.models import User, Permission
from django.contrib.contenttypes.models import ContentType

def populate():

    hosp1 = Hospital(name = 'Strong')
    hosp2 = Hospital(name = 'Rochester General')
    hosp1.save()
    hosp2.save()

    user_content = ContentType.objects.get_for_model(User)
    patientPerm = Permission.objects.create(codename='patient',name='Is Patient',content_type=user_content)
    doctorPerm = Permission.objects.create(codename='doctor',name='Is Doctor',content_type=user_content)
    nursePerm = Permission.objects.create(codename='nurse',name='Is Nurse',content_type=user_content)       
    patientPerm.save()
    doctorPerm.save()
    nursePerm.save()
        
    
    patientuser1 = User.objects.create_user(username='test_patient',email='test_patient@rit.edu',password = 'pass')
    patientuser1.first_name = 'Test'
    patientuser1.last_name = 'Patient'
    patientuser1.user_permissions.add(patientPerm)
    patientuser1.save()

    patient1 = Patient(firstName= 'Test',\
                 lastName= 'Patient', \
                 hospital=hosp1, \
                 userNameField='test_patient', \
                 email='test_patient@rit.edu', \
                 city='Rochester', \
                 state='New York', \
                 address1='test road.', \
                 phone='(888) 888-8888', \
                 insuranceID= '001', \
                 insuranceName='testcare', \
                 emergencyContactEmail='sburtner@rit.edu', \
                 emergencyContactFirstName='Stuart', \
                 emergencyContactLastName='Burtner', \
                 emergencyContactPhone='(555) 555-5555', \
                 medicalInformation='nothing')
    patient1.save()

    patientuser2 = User.objects.create_user(username='richard',email='RichardPosterior@rit.edu',password = 'pass')
    patientuser2.first_name = 'Richard'
    patientuser2.last_name = 'Posterior'
    patientuser2.user_permissions.add(patientPerm)
    patientuser2.save()

    patient2 = Patient(firstName= 'Richard',\
                 lastName= 'Posterior', \
                 hospital=hosp1, \
                 userNameField='richard', \
                 email='RichardPosterior@rit.edu', \
                 city='Rochester', \
                 state='New York', \
                 address1='007 Bond st.', \
                 phone='(888) 999-8888', \
                 insuranceID= '002', \
                 insuranceName='apathetiCare', \
                 emergencyContactEmail='sburtner@rit.edu', \
                 emergencyContactFirstName='Stuart', \
                 emergencyContactLastName='Burtner', \
                 emergencyContactPhone='(555) 555-5555', \
                 medicalInformation='nothing')
    patient2.save()    

    patientuser3 = User.objects.create_user(username='bill',email='bGates@rit.edu',password = 'pass')
    patientuser3.first_name = 'Bill'
    patientuser3.last_name = 'Gates'
    patientuser3.user_permissions.add(patientPerm)
    patientuser3.save()

    patient3 = Patient(firstName= 'Bill',\
                 lastName= 'Gates', \
                 hospital=hosp2, \
                 userNameField='bill', \
                 email='bGates@rit.edu', \
                 city='Rochester', \
                 state='New York', \
                 address1='010 Silicon Val.', \
                 phone='(888) 777-8888', \
                 insuranceID= '003', \
                 insuranceName='apathetiCare', \
                 emergencyContactEmail='sburtner@rit.edu', \
                 emergencyContactFirstName='Stuart', \
                 emergencyContactLastName='Burtner', \
                 emergencyContactPhone='(555) 555-5555', \
                 medicalInformation='nothing')
    patient3.save()        
    patientuser4 = User.objects.create_user(username='rastley',email='never@gunna.give',password = 'pass')
    patientuser4.first_name = 'Rick'
    patientuser4.last_name = 'Astley'
    patientuser4.user_permissions.add(patientPerm)
    patientuser4.save()

    patient4 = Patient(firstName= 'Rick',\
                 lastName= 'Astley', \
                 hospital=hosp2, \
                 userNameField='rastley', \
                 email='never@gunna.give', \
                 city='You', \
                 state='Down.', \
                 address1='Gunna 137.', \
                 phone='(YOU) 11P-N3V4', \
                 insuranceID= '004', \
                 insuranceName='notGunnaHurtYou', \
                 emergencyContactEmail='sburtner@rit.edu', \
                 emergencyContactFirstName='Stuart', \
                 emergencyContactLastName='Burtner', \
                 emergencyContactPhone='(555) 555-5555', \
                 medicalInformation='nothing')
    patient4.save()        

    doctorUser1 = User.objects.create_user(username='test_doctor',email='test_doctor@rit.edu', password = 'pass')
    doctorUser1.first_name = 'Test'
    doctorUser1.last_name = 'Doctor'
    doctorUser1.user_permissions.add(doctorPerm)
    doctorUser1.save()
    doctor1 = Doctor(userNameField= 'test_doctor',\
                 firstName= 'Test',\
                 lastName= 'Doctor',\
                 phone= '(333) 333-3333')

    doctor1.save()

    doctorUser2 = User.objects.create_user(username='mister',email='mLabodomy@rit.edu', password = 'pass')
    doctorUser2.first_name = 'Test'
    doctorUser2.last_name = 'Doctor'
    doctorUser2.user_permissions.add(doctorPerm)
    doctorUser2.save()    
    doctor2 = Doctor(userNameField= 'mister',\
                 firstName= 'Mister',\
                 lastName= 'Labotamy',\
                 phone= '(585) 315-6030')

    doctor2.save()

    nurseUser1 = User.objects.create_user(username='test_nurse',email='test_nurse@rit.edu',password = 'pass')
    nurseUser1.first_name = 'Test'
    nurseUser1.last_name = 'Nurse'
    nurseUser1.user_permissions.add(nursePerm)
    nurseUser1.save()
    nurse1 = Nurse(userNameField = 'test_nurse',\
                firstName = 'Test',\
                lastName = 'Nurse',\
                phone = '(555) 555-5555',\
                hospital = hosp1)
    nurse1.save()

    nurseUser2 = User.objects.create_user(username='amy',email='amynursington@rit.edu',password = 'pass')
    nurseUser2.first_name = 'Amy'
    nurseUser2.last_name = 'Nursington'
    nurseUser2.user_permissions.add(nursePerm)
    nurseUser2.save()
    nurse2 = Nurse(userNameField = 'amy',\
            	firstName = 'Amy',\
                lastName = 'Nursington',\
                phone = '(444) 444-4444',\
                hospital = hosp2)    
    nurse2.save()
    admin = User.objects.create_superuser(username='test_admin',password='pass',email='test_admin@test.com')
    admin.first_name='Test'
    admin.last_name='Admin'
    admin.save()
    
populate()
print('Initialization complete')
input("Press enter to continue")
