# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0015_adminnewsfeed'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='patient',
            name='address2',
        ),
    ]
