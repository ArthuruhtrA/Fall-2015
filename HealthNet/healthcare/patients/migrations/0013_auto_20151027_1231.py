# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0012_prescription'),
    ]

    operations = [
        migrations.CreateModel(
            name='PatientTest',
            fields=[
                ('id', models.UUIDField(serialize=False, primary_key=True, default=uuid.uuid4, editable=False)),
                ('dateTime', models.DateTimeField()),
                ('name', models.CharField(max_length=100)),
                ('details', models.CharField(max_length=1000)),
                ('doctor', models.ForeignKey(to='patients.Doctor')),
                ('patient', models.ForeignKey(to='patients.Patient')),
            ],
        ),
        migrations.AlterField(
            model_name='prescription',
            name='doctor',
            field=models.ForeignKey(to='patients.Doctor'),
        ),
    ]
