#!/usr/bin/python

# We need to find users who send mail mail to big number of recipients
# This program will list top10 senders from Groupwise log file
# Yury Frolov

from collections import defaultdict
from operator import itemgetter
import sys

Mailers = []
Log = defaultdict(list)

# First read all log and parse the MSG IDs, because Groupwise doesn't care about ordering in logs
# dictionary: ['MSGid', [array of strings]]

with open(sys.argv[1], 'r') as f:
    for line in f:
        str = line.split(' ')
        if str[2] == 'MSG':
            MSG_id = str[3]
            Log[MSG_id].append(line)

f.close()

MSG_id = 0

for (Msg_id, lines) in Log.items():
    RecipientCount = 0
    for line in lines:
        str = line.split(' ')
        if str[4] == "Sender:":
            Sender = str[5]

        if str[4] == "Recipient:":
            RecipientCount += 1

    Mailers.append([Sender, RecipientCount, Msg_id])

SortedMailers = sorted(Mailers, key=itemgetter(1), reverse = True)
for mailer in SortedMailers[:10]:
    print mailer



