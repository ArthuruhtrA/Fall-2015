# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0010_nurse_isunread'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='nurse',
            name='isUnread',
        ),
        migrations.AddField(
            model_name='privatemessage',
            name='isUnread',
            field=models.BooleanField(default=True),
        ),
    ]
