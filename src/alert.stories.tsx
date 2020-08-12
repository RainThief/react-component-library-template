import React from 'react';
import { storiesOf } from '@storybook/react';
import { withKnobs, text } from '@storybook/addon-knobs';
import { Alert } from './alert';

const stories = storiesOf('Alert', module);

stories.addDecorator(withKnobs);

const TITLE = 'Alert Title';
const DESCRIPTION =
  'This is the alert description. It provides context to the user,'
  + 'bringing attention to information that needs to be consumed.';

stories.add('With title', () => {
  return (
    <Alert title={text('Title', TITLE)}>{text('Children', DESCRIPTION)}</Alert>
  );
});

stories.add('Without title', () => {
  return <Alert>{text('Children', DESCRIPTION)}</Alert>;
});
