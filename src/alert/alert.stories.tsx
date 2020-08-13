import React from 'react';
import { Meta } from '@storybook/react';
import { text } from '@storybook/addon-knobs';
import { Alert } from './alert';
import { action } from '@storybook/addon-actions';

export default {
  title: 'Alert',
  component: Alert,
} as Meta;

const title = 'Alert Title';
const description =
  'This is the alert description. It provides context to the user,'
  + 'bringing attention to information that needs to be consumed.';

export const noTitle: React.SFC<unknown> = () => <Alert>{text('Content', description)}</Alert>;

export const withTitle: React.SFC<unknown> = () => {
  return <Alert title={text('title', title)} >{text('Content', description)}</Alert>;
};

export const noTitleWithClose: React.SFC<unknown> = () => {
  return <Alert onClose={action('close')} >{text('Content', description)}</Alert>;
};

export const withTitleWithClose: React.SFC<unknown> = () => {
  return <Alert onClose={action('close')} title={text('title', title)} >{text('Content', description)}</Alert>;
};
