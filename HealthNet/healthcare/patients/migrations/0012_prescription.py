# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0011_auto_20151019_1215'),
    ]

    operations = [
        migrations.CreateModel(
            name='Prescription',
            fields=[
                ('id', models.UUIDField(default=uuid.uuid4, serialize=False, editable=False, primary_key=True)),
                ('dateTime', models.DateTimeField()),
                ('name', models.CharField(max_length=100)),
                ('reason', models.CharField(max_length=1000)),
                ('doctor', models.ForeignKey(to='patients.Doctor', related_name='doctor')),
                ('patient', models.ForeignKey(to='patients.Patient')),
            ],
        ),
    ]
