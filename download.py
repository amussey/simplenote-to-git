from simplenote import Simplenote
from decimal import Decimal
import sys

username = sys.argv[1]
password = sys.argv[2]


simplenote = Simplenote(username, password)

noteresponse = simplenote.get_note_list()
last_update_file = open('notes/.last_update', 'r')
try:
    last_update = Decimal(last_update_file.read())
except Exception as e:
    last_update = Decimal('0')
last_update_file.close()
most_recently_updated = '0'

notes = noteresponse[0]
print "Checking %d notes..." % len(notes)
for note in notes:
    if (Decimal(note['modifydate']) > last_update):
        print '    Reading contents of %s' % note['key']
        note_data = simplenote.get_note(note['key'])
        print '    Writing contents of %s' % note['key']
        filename = 'notes/%s' % note['key']
        f = open(filename, 'w')
        f.write(note_data[0]['content'])
        f.close()
    else:
        print 'Skipped %s, no changes.' % note['key']
    if (Decimal(note['modifydate']) > Decimal(most_recently_updated)):
        most_recently_updated = note['modifydate']

last_update_file = open('notes/.last_update', 'w')
last_update_file.write(most_recently_updated)
last_update_file.close()

print 'Download of notes complete.'
