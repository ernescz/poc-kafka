from kafka import KafkaConsumer
from kafka import KafkaProducer
from daemonize import Daemonize
from json import loads
from json import dumps
import statsd
import datetime as d
import time as t 

def UnixConverter():
  """
  Consumes messages from 'input', transforms to date string and
  sends to topic 'output'
  """
  time_delay = 1

  # Kafka consumer from 'input' topic (Unix timestamp in ms):
  consumer = KafkaConsumer(
      'input',
      bootstrap_servers=['192.168.100.10:9092'],
      auto_offset_reset='earliest',
      enable_auto_commit=True,
      group_id='input-group',
    )

  # Kafka producer for 'output' topic:
  producer = KafkaProducer(
      bootstrap_servers=['192.168.100.10:9092'],
      value_serializer=lambda x: 
      dumps(x, default=str).encode('utf-8')
    )

  # statsd connectors for pushing app metrics:
  statsd_cli = statsd.StatsClient('192.168.100.10', 9125, prefix="consumer")

  # Process the messages in topic:
  for message in consumer:
    # Decode the message from stream bytes, set type to int and convert to ISO:
    message = message.value.decode('UTF-8')
    message_int = int(message)
    unix_seconds = int(message_int / 1000)
    iso_date = d.datetime.fromtimestamp(unix_seconds)
    print('Got the value of {}'.format(iso_date))
    # Increment stats with the number of consumed messages (consumer_consumed_unix):
    statsd_cli.incr("consumed_unix")

    # Send the result to the 'output' topic, throtle the loop by "time_delay":
    producer.send('output', iso_date)
    t.sleep(time_delay)
    # Increment stats with the number of produced messages (consumer_produced_iso);
    statsd_cli.incr("produced_iso")


# Start and daemonize the app:
pid = "/tmp/unix_consumer.pid"
daemon = Daemonize(app="unix_consumer", pid=pid, action=UnixConverter)
daemon.start()
