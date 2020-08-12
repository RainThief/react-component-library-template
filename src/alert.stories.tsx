import React from 'react';
import { storiesOf } from '@storybook/react';
import { withKnobs, text } from '@storybook/addon-knobs';
import { Alert } from './alert';
import { action } from '@storybook/addon-actions';


const stories = storiesOf('Alert', module);
const withCloseStories = storiesOf('Alert/withClose', module);

stories.addDecorator(withKnobs);

const title = 'Alert Title';
const description =
  'This is the alert description. It provides context to the user,'
  + 'bringing attention to information that needs to be consumed.';

stories.add('With title', () => {
  return (
    <Alert title={text('Title', title)} >{text('Children', description)}</Alert>
  );
});

stories.add('Without title', () => {
  return <Alert>{text('Children', description)}</Alert>;
});

withCloseStories.add('With title', () => {
  return (
    <Alert title={text('Title', title)} onClose={action('close')}>{text('Children', description)}</Alert>
  );
});

withCloseStories.add('Without title', () => {
  return (
    <Alert onClose={action('close')}>{text('Children', description)}</Alert>
  );
});
