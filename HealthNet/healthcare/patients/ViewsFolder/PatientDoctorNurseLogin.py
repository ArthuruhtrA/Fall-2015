from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from django.contrib import auth
from ..models import log_add

# Create your views here.


def index(request):
    if request.user.is_authenticated and not request.user.is_anonymous():
        return HttpResponseRedirect("/calendar")
    if request.method == "POST":
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')
        user = auth.authenticate(username=username, password=password)
        if user is not None and user.is_active:
            # Correct password, and the user is marked "active"
            auth.login(request, user)

            log_add("Patient " + user.first_name + " " + user.last_name + " logged in.")
            # Redirect to a success page.
            return HttpResponseRedirect("/calendar")
        else:
            # Show an error page
            return HttpResponseRedirect("/login")
    else :
        return render(request, 'patients/loginPage.html', {})