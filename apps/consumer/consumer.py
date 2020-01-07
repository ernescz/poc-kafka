from kafka import KafkaConsumer
from kafka import KafkaProducer
from json import loads
from json import dumps
import datetime as d

# Kafka consumer from 'input' topic (Unix timestamp in ms)
consumer = KafkaConsumer(
    'input',
    bootstrap_servers=['192.168.100.10:9092'],
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='input-group',
  )

# Kafka producer for 'output' topic (ISO date format)
producer = KafkaProducer(
    bootstrap_servers=['192.168.100.10:9092'],
    value_serializer=lambda x: 
    dumps(x, default=str).encode('utf-8')
  )

# Process the messages in topic:
for message in consumer:
  # Decode the message that comes in stream bytes, set type to int and convert to ISO:
  message = message.value.decode('UTF-8')
  message_int = int(message)
  unix_seconds = int(message_int / 1000)
  iso_date = d.datetime.fromtimestamp(unix_seconds)
  print('Got the value of {}'.format(iso_date))

  # Send the result to the 'output' topic:
  producer.send('output', iso_date)

