# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0002_auto_20150928_1428'),
    ]

    operations = [
        migrations.AddField(
            model_name='doctor',
            name='userNameField',
            field=models.CharField(default='usernametest', max_length=1000),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='nurse',
            name='userNameField',
            field=models.CharField(default='usernametest', max_length=1000),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='patient',
            name='userNameField',
            field=models.CharField(default='usernametest', max_length=1000),
            preserve_default=False,
        ),
    ]
