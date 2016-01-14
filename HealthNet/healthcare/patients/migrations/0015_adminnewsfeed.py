# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0014_patientmedicalfile'),
    ]

    operations = [
        migrations.CreateModel(
            name='AdminNewsFeed',
            fields=[
                ('id', models.UUIDField(serialize=False, primary_key=True, default=uuid.uuid4, editable=False)),
                ('dateTime', models.DateTimeField()),
                ('message', models.CharField(max_length=1000)),
            ],
        ),
    ]
