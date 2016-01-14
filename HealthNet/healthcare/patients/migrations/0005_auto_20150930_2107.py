# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0004_auto_20150929_2158'),
    ]

    operations = [
        migrations.AddField(
            model_name='patient',
            name='emergencyContactEmail',
            field=models.CharField(default='qwerty', max_length=1000),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='patient',
            name='emergencyContactFirstName',
            field=models.CharField(default='qwerty', max_length=1000),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='patient',
            name='emergencyContactLastName',
            field=models.CharField(default='qwerty', max_length=1000),
            preserve_default=False,
        ),
    ]
