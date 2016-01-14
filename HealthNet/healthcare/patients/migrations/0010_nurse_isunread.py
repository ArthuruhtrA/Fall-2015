# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0009_auto_20151017_1856'),
    ]

    operations = [
        migrations.AddField(
            model_name='nurse',
            name='isUnread',
            field=models.BooleanField(default=True),
        ),
    ]
