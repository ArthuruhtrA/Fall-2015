# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0008_auto_20151017_0152'),
    ]

    operations = [
        migrations.CreateModel(
            name='HospitalVisit',
            fields=[
                ('id', models.UUIDField(serialize=False, editable=False, primary_key=True, default=uuid.uuid4)),
                ('reason', models.CharField(max_length=1000)),
                ('dateAdmitted', models.DateTimeField()),
                ('dateDischarged', models.DateTimeField()),
            ],
        ),
        migrations.AddField(
            model_name='patient',
            name='isAdmitted',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='hospitalvisit',
            name='patient',
            field=models.ForeignKey(to='patients.Patient'),
        ),
    ]
