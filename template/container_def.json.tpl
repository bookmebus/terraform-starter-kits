[
  {
    ${custom_command}
    "name": "${container_name}",
    "image": "${docker_image_url}",
    "cpu": ${container_cpu},
    "memory": ${container_memory},
    "portMappings": [
      {
        "containerPort": ${container_port},
        "protocol": "tcp"
      },
      {
        "containerPort": 22,
        "protocol": "tcp"
      }
    ],
    "secrets": [
      {
        "name": "SSH_PUBLIC_KEY",
        "valueFrom": "${ssh_public_key_arn}"
      }
    ],
    "environment": [
      {"name": "ACTIVE_STORAGE_CDN", "value": "${active_storage_cdn}"},
      {"name": "APP_NAME", "value": "${app_name}"},
      {"name": "ASSET_HOST_URL", "value": "${asset_host_url}"},
      {"name": "AWS_BUCKET_NAME", "value": "${bucket_Name}"},
      {"name": "AWS_REGION", "value": "${region}"},

      {"name": "BLAZER_DATABASE_URL", "value": "${blazer_database_url}"},
      {"name": "BLAZER_SLACK_WEBHOOK_URL", "value": "${blazer_slack_webhook_url}"},

      {"name": "DEFAULT_EMAIL_FOR_PAYMENT", "value": "${default_email_for_payment}"},
      {"name": "DEVISE_SECRET_KEY", "value": "${device_secret_key}"},
      {"name": "ELASTICSEARCH_URL", "value": "${es_url}"},
      {"name": "EXCEPTION_NOTIFY_ENABLE", "value": "${exception_notification_enable}"},
      {"name": "EXCEPTION_SLACK_WEBHOOK_URL", "value": "${exception_slack_webhook_url}"},
      {"name": "EXCEPTION_CHANNEL_ID", "value": "${exception_channel_id}"},
      {"name": "FB_APP_ID", "value": "${fb_app_id}"},
      {"name": "FIREBASE_PROJECT_ID", "value": "${firebase_project_id}"},
      {"name": "FIREBASE_SENDER_ID", "value": "${firebase_sender_id}"},
      {"name": "FIREBASE_SERVER_KEY", "value": "${firebase_server_key}"},
      {"name": "FORCE_SSL", "value": "true"},

      {"name": "DEFAULT_URL_HOST", "value": "${host}"},
      {"name": "GOOGLE_TAG_MANAGER", "value": "${google_tag_manager}"},

      {"name": "MEMCACHE_SERVERS", "value": "${memcached_servers}"},
      {"name": "MODE_ENV", "value": "${app_mode}"},
      {"name": "RAILS_TASK_NAME", "value": "${rails_task_name}"},
      {"name": "PROTECTED_USERNAME", "value": "${protected_username}"},
      {"name": "PROTECTED_PASSWORD", "value": "${protected_password}"},
      {"name": "RAILS_ENV", "value": "production"},
      {"name": "RAILS_LOG_TO_STDOUT", "value": "1"},
      {"name": "RAILS_MASTER_KEY", "value": "${rails_master_key}"},
      {"name": "RAILS_MIN_INSTANCES", "value": "${rails_min_instances}"},
      {"name": "RAILS_MAX_INSTANCES", "value": "${rails_max_instance}"},
      {"name": "RAILS_MAX_THREADS", "value": "${rails_max_threads}"},
      {"name": "REDIS_URL", "value": "${redis_url}"},
      {"name": "SHOW_TOPBAR", "value": "${show_topbar}"},
      {"name": "SIDEKIQ_USERNAME", "value": "${sidekiq_username}"},
      {"name": "SIDEKIQ_PASSWORD", "value": "${sidekiq_password}"},
      {"name": "SMS_SENDER_ID", "value": "${sms_sender_id}"},
      {"name": "SMTP_SERVER", "value": "${smtp_server}"},
      {"name": "SMTP_USERNAME", "value": "${smtp_username}"},
      {"name": "SMTP_PASSWORD", "value": "${smtp_password}"},
      {"name": "TIME_ZONE", "value": "${time_zone}"},
      {"name": "VSHOP_DB_HOST", "value": "${rds_db_host}"},
      {"name": "VSHOP_DB_NAME", "value": "${rds_db_name}"},
      {"name": "VSHOP_DB_NAME_PRODUCTION", "value": "${rds_db_name}"},
      {"name": "VSHOP_DB_USER", "value": "${rds_db_user}"},
      {"name": "VSHOP_DB_PASSWORD", "value": "${rds_db_password}"},
      {"name": "TOUCH_REDEPLOY", "value": "${touch_redeploy}"}
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "${log_group_name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
