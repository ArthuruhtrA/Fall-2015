# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0007_log_privatemessage'),
    ]

    operations = [
        migrations.RenameField(
            model_name='privatemessage',
            old_name='reciever',
            new_name='receiver',
        ),
    ]
