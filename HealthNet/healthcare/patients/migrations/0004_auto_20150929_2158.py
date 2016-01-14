# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0003_auto_20150929_2147'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='patient',
            name='emergencyContact',
        ),
        migrations.AddField(
            model_name='patient',
            name='emergencyContactPhone',
            field=models.CharField(max_length=1000, default=5555555555),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='patient',
            name='medicalInformation',
            field=models.CharField(max_length=1000, default='no information'),
            preserve_default=False,
        ),
    ]
