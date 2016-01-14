# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('patients', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='appointment',
            name='doctor',
            field=models.ForeignKey(to='patients.Doctor'),
        ),
        migrations.AlterField(
            model_name='appointment',
            name='hospital',
            field=models.ForeignKey(to='patients.Hospital'),
        ),
        migrations.AlterField(
            model_name='appointment',
            name='patient',
            field=models.ForeignKey(to='patients.Patient'),
        ),
        migrations.AlterField(
            model_name='nurse',
            name='hospital',
            field=models.ForeignKey(to='patients.Hospital'),
        ),
    ]
