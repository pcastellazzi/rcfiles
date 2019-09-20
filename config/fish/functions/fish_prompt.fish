function fish_prompt
  echo -s (set_color green) (prompt_pwd)

  if set -q AWS_PROFILE
    set my_aws_profile $AWS_PROFILE
  end

  if set -q AWS_VAULT
    set my_aws_profile $AWS_VAULT
  end

  if set -q AUTODESK_ENVIRONMENT
    set my_aws_profile $AUTODESK_ENVIRONMENT
  end

  if set -q my_aws_profile
    echo -n -s (set_color blue) "{$my_aws_profile} "
  end

  echo -n -s (set_color yellow) (__fish_git_prompt "[%s] ")
  echo -n -s (set_color normal) "% "
end
