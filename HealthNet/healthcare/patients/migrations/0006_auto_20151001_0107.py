# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0005_auto_20150930_2107'),
    ]

    operations = [
        migrations.RenameField(
            model_name='appointment',
            old_name='datetime',
            new_name='dateTime',
        ),
        migrations.AlterField(
            model_name='patient',
            name='state',
            field=models.CharField(max_length=1000),
        ),
    ]
