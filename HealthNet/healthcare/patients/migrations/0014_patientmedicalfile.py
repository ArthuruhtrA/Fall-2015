# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0013_auto_20151027_1231'),
    ]

    operations = [
        migrations.CreateModel(
            name='PatientMedicalFile',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, editable=False, primary_key=True, serialize=False)),
                ('dateTime', models.DateTimeField()),
                ('file', models.FileField(upload_to='documents/%Y/%m/%d')),
                ('doctor', models.ForeignKey(to='patients.Doctor')),
                ('patient', models.ForeignKey(to='patients.Patient')),
            ],
        ),
    ]
